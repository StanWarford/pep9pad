//
//  AssemblerModel.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

var assembler = AssemblerModel()


// MARK: Regular expressions for lexical analysis
// NOTE: the following variables use the `try!` modifier to force a pattern-matching attempt. `NSRegularExpression` throws an error if the pattern is invalid. Our patterns are fixed and thus will never `throw` an error.
let rxAddrMode = try! NSRegularExpression(pattern: "^((,)(\\s*)(i|d|x|n|s(?![fx])|sx(?![f])|sf|sfx){1}){1}", options: [.caseInsensitive])
let rxCharConst = try! NSRegularExpression(pattern: "^((\')(?![\'])(([^\'\\\\]){1}|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))(\'))", options: [.caseInsensitive])
let rxComment = try! NSRegularExpression(pattern: "^(({1})(.)*)", options: [.caseInsensitive])
let rxDecConst = try! NSRegularExpression(pattern: "^((([+|-]{0,1})([0-9]+))|^(([1-9])([0-9]*)))", options: [.caseInsensitive])
let rxDotCommand = try! NSRegularExpression(pattern: "^((.)(([A-Z|a-z]{1})(\\w)*))", options: [.caseInsensitive])
let rxHexConst = try! NSRegularExpression(pattern: "^((0(?![x|X]))|((0)([x|X])([0-9|A-F|a-f])+)|((0)([0-9]+)))", options: [.caseInsensitive])
let rxIdentifier = try! NSRegularExpression(pattern: "^((([A-Z|a-z|_]{1})(\\w*))(:){0,1})", options: [.caseInsensitive])
let rxStringConst = try! NSRegularExpression(pattern: "^((\")((([^\"\\\\])|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))*)(\"))", options: [.caseInsensitive])

// MARK: Regular expressions for trace tag analysis
let rxFormatTag = try! NSRegularExpression(pattern: "(#((1c)|(1d)|(1h)|(2d)|(2h))((\\d)+a)?(\\s|$))", options: [.caseInsensitive])
let rxSymbolTag = try! NSRegularExpression(pattern: "#([a-zA-Z][a-zA-Z0-9]{0,7})", options: [.caseInsensitive])
let rxArrayMultiplier = try! NSRegularExpression(pattern: "((\\d)+)a", options: [.caseInsensitive])





/// The highest level of abstraction in Pep9Pad.
class AssemblerModel {
    
    // MARK: - Properties
    
    /// Parsed source code, an array of Code objects.
    var source: [Code] = []
    /// Parsed object code, an array of integers.
    var object: [Int] = []
    /// The listing generated from the most recent assembler call.
    var listing: [String] = []
    
    
    /// The number of times a .BURN directive is found in the current project.
    /// Should equal 0 unless installing an OS (in which case it should be equal to (not greater than) 1).
    var burnCount: Int = 0
    /// The number of bytes occupied by the current line.
    var byteCount: Int = 0
    /// The end of the ROM, written in Asmb as .BURN 0xFFFF or whatever.
    var dotBurnArgument: Int = 0
    /// The beginning of ROM, which is the dotBurnArgument - the size of the OS.
    var romStartAddress: Int = 0
    /// The list of all referenced symbols in the assembly program.  
    /// Each element is a 2-touple with a `source` and `lineNumber` attribute.
    var referencedSymbols: [ReferencedSymbol] = []
    
    
    
    // MARK: - Methods
    // Pre: self.textView.text contains a Pep/9 source program.
    // Post: If the program assembles correctly, true is returned, and sourceCode is populated
    // with the code objects. Otherwise false is returned and codeList is partially populated.
    // Post: pep.symbolTable is populated with values not adjusted for .BURN.
    // Post: pep.byteCount is the byte count for the object code not adjusted for .BURN.
    // Post: pep.burnCount is the number of .BURN instructions encountered in the source program.
    func assemble() -> Bool {
        maps.burnCount = 0
        
        // Initialize these here, otherwise the processSourceLine call later on complains that the passed-by-ref variables are not initialized.
        var sourceLine: String = ""
        var errorString: String = ""
        var sourceCodeList: [String]
        var code: Code = Code()
        var lineNum: Int = 0
        var dotEndDetected: Bool = false
        
        //removeErrorMessages()
        referencedSymbols.removeAll()
        maps.memAddrssToAssemblerListing.removeAll()
        maps.symbolTable.removeAll()
        maps.adjustSymbolValueForBurn.removeAll()
        maps.symbolFormat.removeAll()
        maps.symbolFormatMultiplier.removeAll()
        maps.symbolTraceList.removeAll() // Does this clear the lists within the map?
        maps.globalStructSymbols.removeAll()
        maps.blockSymbols.removeAll()
        maps.equateSymbols.removeAll()
        source.removeAll()
        
        sourceCodeList = projectModel.sourceStr.components(separatedBy: "\n")
        maps.byteCount = 0
        maps.burnCount = 0
        
        while (lineNum < sourceCodeList.count && !dotEndDetected) {
            sourceLine = sourceCodeList[lineNum]
            if (!processSourceLine(&sourceLine, lineNum: lineNum, code: &code, errorString: &errorString, dotEndDetected: &dotEndDetected)) {
                source[lineNum].comment.append(errorString)
                return false
            }
            source.append(code)
            lineNum += 1
        }
        
        // check for existence of .END
        if (!dotEndDetected) {
            errorString = ";ERROR: Missing .END sentinel."
            source[0].comment.append(errorString)
            return false
        }
        
        // check size of program
        if (maps.byteCount > 65535) {
            errorString = ";ERROR: Object code size too large to fit into memory."
            source[0].comment.append(errorString)
            return false
        }
        
        // check for unused symbols
        for i in 0..<referencedSymbols.count {
            if (!Array(maps.symbolTable.keys).contains(assembler.referencedSymbols[i].symbol)
                && !(assembler.referencedSymbols[i].symbol == "charIn")
                && !(assembler.referencedSymbols[i].symbol == "charOut")) {
                errorString = ";ERROR: Symbol " + referencedSymbols[i].symbol + " is used but not defined."
                projectModel.appendMessageInSource(atLine: referencedSymbols[i].lineNumber, message: errorString)
                return false
            }
        }
        
        
        maps.traceTagWarning = false

        // check format trace tags
        for i in 0..<assembler.source.count {
            if (!assembler.source[i].processFormatTraceTags(at: &lineNum, err: &errorString)) {
                projectModel.appendMessageInSource(atLine: lineNum, message: errorString)
                maps.traceTagWarning = true
            }
        }
        
        // check symbol trace tags
        if !maps.traceTagWarning && !(maps.blockSymbols.isEmpty && maps.equateSymbols.isEmpty) {
            for i in 0..<assembler.source.count {
                if !(assembler.source[i].processSymbolTraceTags(at: &lineNum, err: &errorString)) {
                    projectModel.appendMessageInSource(atLine: lineNum, message: errorString)
                    maps.traceTagWarning = true
                }
            }
        }
        
        // these have been moved to the assembleSource function in the Pep9DetailController
        //traceVC.setMemoryTrace()
        //listingVC.showListing()
        
        return true
        
    }
    
    func getToken(sourceLine: inout String, token: inout ELexicalToken, tokenString: inout String) -> Bool {
        
        sourceLine = sourceLine.trimmed()
        if (sourceLine.characters.count == 0) {
            token = .lt_EMPTY
            tokenString = ""
            return true
        }
        let firstChar: Character = sourceLine.characters.first!
        if (firstChar == ",") {
            if !rxAddrMode.appearsIn(sourceLine) {
                tokenString = ";ERROR: Malformed addressing mode."
                return false
            }
            token = .lt_ADDRESSING_MODE
            tokenString = rxAddrMode.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar == "'") {
            if !rxCharConst.appearsIn(sourceLine) {
                tokenString = ";ERROR: Malformed character constant."
                return false
            }
            token = .lt_CHAR_CONSTANT
            tokenString = rxCharConst.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar == "") {
            if !rxComment.appearsIn(sourceLine) {
                //This error should not occur, as any characters are allowed in a comment.
                tokenString = ";ERROR: Malformed comment"
                return false
            }
            token = .lt_COMMENT
            tokenString = rxComment.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (sourceLine.hasHexPrefix()) {
            if !rxHexConst.appearsIn(sourceLine) {
                tokenString = ";ERROR: Malformed hex constant."
                return false
            }
            token = .lt_HEX_CONSTANT
            tokenString = rxHexConst.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar.isDigit() || firstChar == "+" || firstChar == "-") {
            if !rxDecConst.appearsIn(sourceLine) {
                tokenString = ";ERROR: Malformed decimal constant."
                return false
            }
            token = .lt_DEC_CONSTANT
            tokenString = rxDecConst.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar == ".") {
            if !rxDotCommand.appearsIn(sourceLine) {
                tokenString = ";ERROR: Malformed dot command."
                return false
            }
            token = .lt_DOT_COMMAND
            tokenString = rxDotCommand.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar.isLetter() || firstChar == "_") {
            if !rxIdentifier.appearsIn(sourceLine) {
                // this should not occur, as one-character identifiers are valid
                tokenString = ";ERROR: Malformed identifier."
                return false
            }
            tokenString = rxIdentifier.matchesIn(sourceLine)[0]
            token = tokenString.characters.last == ":" ? .lt_SYMBOL_DEF : .lt_IDENTIFIER
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar == "\"") {
            if !rxStringConst.appearsIn(sourceLine) {
                tokenString = ";ERROR: Malformed string constant."
                return false
            }
            token = .lt_STRING_CONSTANT
            tokenString = rxStringConst.matchesIn(sourceLine)[0]
            sourceLine.remove(0, tokenString.length)
            return true
        }
        tokenString = ";ERROR: Syntax error."
        return false
        
        
        
    }

    func formatMultiplier(_ formatTag: String) -> Int {
        let pos: Int = rxArrayMultiplier.index(ofAccessibilityElement: formatTag)
        if pos > -1 {
            var multiplierTag: String = rxArrayMultiplier.cap(section: 0)
            multiplierTag.chop()
            return Int(multiplierTag)!
        }
        return 1
    }
    
    func formatTagType(formatTag: String) -> ESymbolFormat {
        if formatTag.startsWith(input: "#1c") {
            return ESymbolFormat.F_1C
        }
        if formatTag.startsWith(input: "#1d") {
            return ESymbolFormat.F_1D
        }
        if formatTag.startsWith(input: "#2d") {
            return ESymbolFormat.F_2D
        }
        if formatTag.startsWith(input: "#1h") {
            return ESymbolFormat.F_1H
        }
        if formatTag.startsWith(input: "#2h") {
            return ESymbolFormat.F_2H
        }
        return ESymbolFormat.F_NONE // Should not occur
    }
    
    func tagNumBytes(symbolFormat: ESymbolFormat) -> Int {
        switch symbolFormat {
        case ESymbolFormat.F_1C:
            return 1
        case ESymbolFormat.F_1D:
            return 1
        case ESymbolFormat.F_2D:
            return 2
        case ESymbolFormat.F_1H:
            return 2
        case ESymbolFormat.F_2H:
            return 2
        case ESymbolFormat.F_NONE:
            return 0
        default:
            return -1
        }
    }
    
    func unquotedStringToInt(str: inout String, value: inout Int) {
        var s: String = ""
        if str.startsWith(input: "\\x") || str.startsWith(input: "\\X") {
            str.remove(0, 2)
            s = str.left(num: 2)
            str.remove(0, 2)
            var ok: Bool
            value = s.stringToHex() // MARK: NEED TO MAKE THIS FUNCTION RETURN INT NOT HEX I GUESS
        } else if str.startsWith(input: "\\") {
            str.remove(0, 1)
            s = str.left(num: 2)
            str.remove(0, 2)
            switch s {
            case "b":
                value = 8
            case "f":
                value = 12
            case "n":
                value = 10
            case "r":
                value = 13
            case "t":
                value = 9
            case "v":
                value = 11
            default:
                value = Character(s[0]).toLatin1()
            }
        } else {
            s = str.left(num: 1)
            str.remove(0, 1)
            var temp: Character = s.characters.first!
            value = temp(encoding: NSISOLatin1StringEncoding) // UPDATE
        }
        value += value < 0 ? 256 : 0
    }
    
    func stringToAddrMode (str: String) -> EAddrMode {
        var str = str
        str.remove(0, 1) // Remove the comma
        str = str.trimmed().capitalized
        switch str {
        case "I":
            return EAddrMode.I
        case "D":
            return EAddrMode.D
        case "N":
            return EAddrMode.N
        case "S":
            return EAddrMode.S
        case "SF":
            return EAddrMode.SF
        case "X":
            return EAddrMode.X
        case "SX":
            return EAddrMode.SX
        case "SFX":
            return EAddrMode.SFX
        default:
            return EAddrMode.None
        }
    }
    
    func byteStringLength(str: String) -> Int {
        var string = str
        string.remove(0, 1)  // Remove the leftmost double quote.
        string.chop() // Remove the rightmost double quote.
        var length: Int = 0
        while (string.length > 0) {
            if (str.startsWith(input: "\\x") || str.startsWith(input: "\\X")) {
                string.remove(0, 4) // Remove the \xFF
            }
            else if (str.startsWith(input: "\\")) {
                string.remove(0, 2) // Remove the quoted character
            }
            else {
                string.remove(0, 1) // Remove the single character
            }
            length += 1
        }
        return length
        return 1
    }
    
    func charStringToInt (str: String) -> Int {
        var str = str
        str.remove(0, 1)
        str.chop()
        var value: Int
        assembler.unquotedStringToInt(str: &str, value: &value)
        return value
    }
    
    func string2ArgumentToInt(str: String) -> Int {
        var valueA: Int
        var valueB: Int
        var str = str
        str.remove(0, 1)
        str.chop()
        assembler.unquotedStringToInt(str: &str, value: &valueA)
        if str.length == 0 {
            return valueA
        } else {
            assembler.unquotedStringToInt(str: &str, value: &valueB)
            valueA = 256 * valueA + valueB
            if valueA < 0 {
                valueA = valueA + 65536
            }
            return valueA
        }
    }
    
    /// Pre: sourceLine has one line of source code.
    /// Pre: lineNum is the line number of the source code.
    /// Post: If the source line is valid, true is returned and code is set to the source code for the line.
    /// Post: dotEndDetected is set to true if .END is processed. Otherwise it is set to false.
    /// Post: maps.byteCount is incremented by the number of bytes generated.
    /// Post: If the source line is not valid, false is returned and errorString is set to the error message.
    func processSourceLine(_ sourceLine: inout String, lineNum: Int, code: inout Code, errorString: inout String, dotEndDetected: inout Bool) -> Bool {
        
        let nonUnaryInstruction = NonUnaryInstruction()
        let dotAddrss = DotAddress()
        
        // placeholder
        return true
        
        var token: ELexicalToken // Passed to getToken.
        var tokenString: String // Passed to getToken.
        var localSymbolDef: String = "" // Saves symbol definition for processing in the following state.
        var localEnumMnemonic: EMnemonic // Key to maps. table lookups.

        
        dotEndDetected = false
        var state: ParseState = ParseState.ps_START
        repeat {
            if !getToken( sourceLine: &sourceLine, token: &token, tokenString: &tokenString) {
                errorString = tokenString
                return false
            }
            switch (state) {
            case .ps_START:
                if (token == ELexicalToken.lt_IDENTIFIER) {
                if (maps.mnemonToEnumMap.keys).contains(tokenString.uppercased()) {
                    localEnumMnemonic = maps.mnemonToEnumMap[tokenString.uppercased()]!
                    if  maps.isUnaryMap[localEnumMnemonic]! {
                        let unaryInstruction = UnaryInstruction()
                        unaryInstruction.symbolDef = ""
                        unaryInstruction.mnemonic = localEnumMnemonic
                        code = unaryInstruction
                        code.memAddress = maps.byteCount
                        maps.byteCount += 1 // One byte generated for unary instruction.
                        state = ParseState.ps_CLOSE
                    }
                    else {
                        nonUnaryInstruction.symbolDef = ""
                        nonUnaryInstruction.mnemonic = localEnumMnemonic
                        code = nonUnaryInstruction
                        code.memAddress = maps.byteCount
                        maps.byteCount += 3 // Three bytes generated for nonunary instruction.
                        state = ParseState.ps_INSTRUCTION
                    }
                }
                else {
                    errorString = ";ERROR: Invalid mnemonic."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_DOT_COMMAND) {
                tokenString.remove(0, 1) // Remove the period
                tokenString = tokenString.capitalized
                if (tokenString == "ADDRSS") {
                    let dotAddress = DotAddress()
                    dotAddress.symbolDef = ""
                    code = dotAddress
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_ADDRSS
                }
                else if (tokenString == "ALIGN") {
                    let dotAlign = DotAlign()
                    dotAlign.symbolDef = ""
                    code = dotAlign
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_ALIGN
                    
                }
                else if (tokenString == "ASCII") {
                    let dotAscii = DotAscii()
                    dotAscii.symbolDef = ""
                    code = dotAscii
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_ASCII
                }
                else if (tokenString == "BLOCK") {
                    let dotBlock = DotBlock()
                    dotBlock.symbolDef = ""
                    code = dotBlock
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_BLOCK
                }
                else if (tokenString == "BURN") {
                    let dotBurn = DotBurn()
                    dotBurn.symbolDef = ""
                    code = dotBurn
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_BURN
                }
                else if (tokenString == "BYTE") {
                    let dotByte = DotByte()
                    dotByte.symbolDef = ""
                    code = dotByte
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_BYTE
                }
                else if (tokenString == "END") {
                    let dotEnd = DotEnd()
                    dotEnd.symbolDef = ""
                    code = dotEnd
                    code.memAddress = maps.byteCount
                    dotEndDetected = true
                    state = ParseState.ps_DOT_END
                }
                else if (tokenString == "EQUATE") {
                    let DotEquate = DotEquate()
                    DotEquate.symbolDef = ""
                    code = DotEquate
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_EQUATE
                }
                else if (tokenString == "WORD") {
                    let dotWord = DotWord()
                    dotWord.symbolDef = ""
                    code = dotWord
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_WORD
                }
                else {
                    errorString = ";ERROR: Invalid dot command."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_SYMBOL_DEF) {
                tokenString.chop() // Remove the colon
                if (tokenString.length > 8) {
                    errorString = ";ERROR: Symbol " + tokenString + " cannot have more than eight characters."
                    return false
                }
                if ((maps.symbolTable[tokenString]) != nil) {
                    errorString = ";ERROR: Symbol " + tokenString + " was previously defined."
                    return false
                }
                localSymbolDef = tokenString
                maps.symbolTable[localSymbolDef] = maps.byteCount
                maps.adjustSymbolValueForBurn[localSymbolDef] = true
                state = ParseState.ps_SYMBOL_DEF
            }
            else if (token == ELexicalToken.lt_COMMENT) {
                let commentOnly = CommentOnly()
                commentOnly.comment = tokenString
                code = commentOnly
                code.memAddress = maps.byteCount
                state = ParseState.ps_COMMENT
            }
            else if (token == ELexicalToken.lt_EMPTY) {
                let blankLine = BlankLine()
                code = blankLine
                code.memAddress = maps.byteCount
                code.sourceCodeLine = lineNum
                state = ParseState.ps_FINISH
            }
            else {
                errorString = ";ERROR: Line must start with symbol definition, mnemonic, dot command, or comment."
                return false
            }
            break
                
            case .ps_SYMBOL_DEF:
                if (token == ELexicalToken.lt_IDENTIFIER){
                    if (maps.mnemonToEnumMap[tokenString.capitalized] != nil) {
                    localEnumMnemonic = maps.mnemonToEnumMap[tokenString.capitalized]!
                        if (maps.isUnaryMap[localEnumMnemonic] != nil) {
                        let unaryInstruction = UnaryInstruction()
                        unaryInstruction.symbolDef = localSymbolDef
                        unaryInstruction.mnemonic = localEnumMnemonic
                        code = unaryInstruction
                        code.memAddress = maps.byteCount
                        maps.byteCount += 1 // One byte generated for unary instruction.
                        state = ParseState.ps_CLOSE
                    }
                    else {
                        let nonUnaryInstruction = NonUnaryInstruction()
                        nonUnaryInstruction.symbolDef = localSymbolDef
                        nonUnaryInstruction.mnemonic = localEnumMnemonic
                        code = nonUnaryInstruction
                        code.memAddress = maps.byteCount
                        maps.byteCount += 3 // Three bytes generated for unary instruction.
                        state = ParseState.ps_INSTRUCTION
                    }
                }
                else {
                    errorString = ";ERROR: Invalid mnemonic."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_DOT_COMMAND) {
                tokenString.remove(0, 1) // Remove the period
                tokenString = tokenString.capitalized
                if (tokenString == "ADDRSS") {
                    let dotAddress = DotAddress()
                    dotAddress.symbolDef = localSymbolDef
                    code = dotAddress
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_ADDRSS
                }
                else if (tokenString == "ASCII") {
                    let dotAscii = DotAscii()
                    dotAscii.symbolDef = localSymbolDef
                    code = dotAscii
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_ASCII
                }
                else if (tokenString == "BLOCK") {
                    let dotBlock = DotBlock()
                    dotBlock.symbolDef = localSymbolDef
                    code = dotBlock
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_BLOCK
                }
                else if (tokenString == "BURN") {
                    let dotBurn = DotBurn()
                    dotBurn.symbolDef = localSymbolDef
                    code = dotBurn
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_BURN
                }
                else if (tokenString == "BYTE") {
                    let dotByte = DotByte()
                    dotByte.symbolDef = localSymbolDef
                    code = dotByte
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_BYTE
                }
                else if (tokenString == "END") {
                    let dotEnd = DotEnd()
                    dotEnd.symbolDef = localSymbolDef
                    code = dotEnd
                    code.memAddress = maps.byteCount
                    dotEndDetected = true
                    state = ParseState.ps_DOT_END
                }
                else if (tokenString == "EQUATE") {
                    let dotEquare = DotEquate()
                    dotEquare.symbolDef = localSymbolDef
                    code = dotEquare
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_EQUATE
                }
                else if (tokenString == "WORD") {
                    let dotWord = DotWord()
                    dotWord.symbolDef = localSymbolDef
                    code = dotWord
                    code.memAddress = maps.byteCount
                    state = ParseState.ps_DOT_WORD
                }
                else {
                    errorString = ";ERROR: Invalid dot command."
                    return false
                }
            }
            else {
                errorString = ";ERROR: Must have mnemonic or dot command after symbol definition."
                return false
            }
            break
            case .ps_INSTRUCTION:
            if (token == ELexicalToken.lt_IDENTIFIER) {
                if (tokenString.length > 8) {
                        errorString = ";ERROR: Symbol " + tokenString + " cannot have more than eight characters."
                        return false
                }
                nonUnaryInstruction.argument = SymbolRefArgument(symbolRef: tokenString)
                assembler.referencedSymbols.append((tokenString, lineNum))
                state = ParseState.ps_ADDRESSING_MODE
            }
            else if (token == ELexicalToken.lt_STRING_CONSTANT) {
                if (assembler.byteStringLength(str: tokenString) > 2) {
                    errorString = ";ERROR: String operands must have length at most two."
                    return false
                }
                nonUnaryInstruction.argument = SymbolRefArgument(symbolRef: tokenString)
                state = ParseState.ps_ADDRESSING_MODE
            }
            else if (token == ELexicalToken.lt_HEX_CONSTANT) {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                var ok: Bool
                var value = tokenString.toInt(&ok, 16)
                if (value < 65536) {
                    assembler.nonUnaryInstruction.argument = HexArgument(value)
                    state = ParseState.ps_ADDRESSING_MODE
                }
                else {
                    errorString = ";ERROR: Hexidecimal constant is out of range (0x0000..0xFFFF)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_DEC_CONSTANT) {
                var ok: Bool
                var value = tokenString.toInt(&ok, 10)
                if ((-32768 <= value) && (value <= 65535)) {
                    if (value < 0) {
                        value += 65536 // Stored as two-byte unsigned.
                        assembler.nonUnaryInstruction.argument = DecArgument(value)
                    }
                    else {
                        assembler.nonUnaryInstruction.argument = UnsignedDecArgument(value)
                    }
                    state = ParseState.ps_ADDRESSING_MODE
                }
                else {
                    errorString = ";ERROR: Decimal constant is out of range (-32768..65535)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_CHAR_CONSTANT) {
                nonUnaryInstruction.argument = CharArgument(char: tokenString)
                state = ParseState.ps_ADDRESSING_MODE
            }
            else {
                errorString = ";ERROR: Operand specifier expected after mnemonic."
                return false
            }
            break
            case .ps_ADDRESSING_MODE:
                if (token == ELexicalToken.lt_ADDRESSING_MODE) {
                    var addrMode: EAddrMode = assembler.stringToAddrMode(tokenString)
                    if ((addrMode.rawValue & maps.addrModesMap[localEnumMnemonic]!) == 0) { // Nested parens required.
                        errorString = ";ERROR: Illegal addressing mode for this instruction."
                        return false
                    }
                    nonUnaryInstruction.addressingMode = addrMode
                    state = ParseState.ps_CLOSE
                }
            else if (maps.addrModeRequiredMap[localEnumMnemonic])! {
                errorString = ";ERROR: Addressing mode required for this instruction."
                return false
            }
            else { // Must be branch type instruction with no addressing mode. Assign default addressing mode.
                    nonUnaryInstruction.addressingMode = EAddrMode.I
                if (token == ELexicalToken.lt_COMMENT) {
                    code.comment = tokenString
                    state = ParseState.ps_COMMENT
                }
                else if (token == ELexicalToken.lt_EMPTY) {
                    code.sourceCodeLine = lineNum
                    state = ParseState.ps_FINISH
                }
                else {
                    errorString = ";ERROR: Comment expected following instruction."
                    return false
                }
            }
            break
                
            case .ps_DOT_ADDRSS:
                if (token == ELexicalToken.lt_IDENTIFIER) {
                if (tokenString.length > 8) {
                    errorString = ";ERROR: Symbol " + tokenString + " cannot have more than eight characters."
                    return false
                }
                DotAddress.memAddress = SymbolRefArgument(symbolRef: tokenString)
                assembler.referencedSymbols.append(tokenString)
                assembler.listOfReferencedSymbolLineNums.append(lineNum)
                maps.byteCount += 2
                state = ParseState.ps_CLOSE
            }
            else {
                errorString = ";ERROR: .ADDRSS requires a symbol argument."
                return false
            }
            break
                
            case .ps_DOT_ALIGN:
                if (token == ELexicalToken.lt_DEC_CONSTANT) {
                var ok: Bool
                var value = tokenString.toInt(&ok, 10)
                if (value == 2 || value == 4 || value == 8) {
                    var numBytes = (value - maps.byteCount % value) % value
                    DotAlign.argument = UnsignedDecArgument(value)
                    DotAlign.numBytesGenerated = UnsignedDecArgument(numBytes)
                    maps.byteCount += numBytes
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Decimal constant is out of range (2, 4, 8)."
                    return false
                }
            }
            else {
                errorString = ";ERROR: .ALIGN requires a decimal constant 2, 4, or 8."
                return false
            }
            break
                
            case .ps_DOT_ASCII:
                if (token == ELexicalToken.lt_STRING_CONSTANT) {
                DotAscii.argument = StringArgument(tokenString)
                maps.byteCount += assembler.byteStringLength(str: tokenString)
                state = ParseState.ps_CLOSE
            }
            else {
                errorString = ";ERROR: .ASCII requires a string constant argument."
                return false
            }
            break
                
            case .ps_DOT_BLOCK:
                if (token == ELexicalToken.lt_DEC_CONSTANT) {
                var ok: Bool
                var value = tokenString.toInt(&ok, 10)
                if ((0 <= value) && (value <= 65535)) {
                    if (value < 0) {
                        value += 65536 // Stored as two-byte unsigned.
                        DotBlock.argument = DecArgument(value)
                    }
                    else {
                        DotBlock.argument = UnsignedDecArgument(value)
                    }
                    maps.byteCount += value
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Decimal constant is out of range (0..65535)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_HEX_CONSTANT) {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                var ok: Bool
                var value = tokenString.toInt(&ok, 16)
                if (value < 65536) {
                    DotBlock.argument = HexArgument(value)
                    maps.byteCount += value
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Hexidecimal constant is out of range (0x0000..0xFFFF)."
                    return false
                }
            }
            else {
                errorString = ";ERROR: .BLOCK requires a decimal or hex constant argument."
                return false
            }
            break
                
            case .ps_DOT_BURN:
                if (token == ELexicalToken.lt_HEX_CONSTANT) {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                var ok: Bool
                var value = tokenString.toInt(&ok, 16)
                if (value < 65536) {
                    DotBurn.argument = HexArgument(value)
                    maps.burnCount += 1
                    maps.dotBurnArgument = value
                    maps.romStartAddress = maps.byteCount
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Hexidecimal constant is out of range (0x0000..0xFFFF)."
                    return false
                }
            }
            else {
                errorString = ";ERROR: .BURN requires a hex constant argument."
                return false
            }
            break
                
            case .ps_DOT_BYTE:
                if (token == ELexicalToken.lt_CHAR_CONSTANT) {
                DotByte.argument = CharArgument(tokenString)
                maps.byteCount += 1
                state = ParseState.ps_CLOSE
            }
            else if (token == ELexicalToken.lt_DEC_CONSTANT) {
                var ok: Bool
                var value = tokenString.toInt(&ok, 10)
                if ((-128 <= value) && (value <= 255)) {
                    if (value < 0) {
                        value += 256 // value stored as one-byte unsigned.
                    }
                    DotByte.argument = DecArgument(value)
                    maps.byteCount += 1
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Decimal constant is out of byte range (-128..255)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_HEX_CONSTANT) {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                var ok: Bool
                var value = tokenString.toInt(&ok, 16)
                if (value < 256) {
                    DotByte.argument = HexArgument(value)
                    maps.byteCount += 1
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Hex constant is out of byte range (0x00..0xFF)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_STRING_CONSTANT) {
                if (assembler.byteStringLength(str: tokenString) > 1) {
                    errorString = ";ERROR: .BYTE string operands must have length one."
                    return false
                }
                DotByte.argument = StringArgument(tokenString)
                maps.byteCount += 1
                state = ParseState.ps_CLOSE
            }
            else {
                errorString = ";ERROR: .BYTE requires a char, dec, hex, or string constant argument."
                return false
            }
            break
                
            case .ps_DOT_END:
                if (token == ELexicalToken.lt_COMMENT) {
                DotEnd.comment = tokenString
                code.sourceCodeLine = lineNum
                state = ParseState.ps_FINISH
            }
            else if (token == ELexicalToken.lt_EMPTY) {
                DotEnd.comment = ""
                code.sourceCodeLine = lineNum
                state = ParseState.ps_FINISH
            }
            else {
                errorString = ";ERROR: Only a comment can follow .END."
                return false
            }
            break
                
            case .ps_DOT_EQUATE:
                if (DotEquate.symbolDef == "") {
                errorString = ";ERROR: .EQUATE must have a symbol definition."
                return false
            }
            else if (token == ELexicalToken.lt_DEC_CONSTANT) {
                var ok: Bool
                var value = tokenString.toInt(&ok, 10)
                if ((-32768 <= value) && (value <= 65535)) {
                    
                    if (value < 0) {
                        value += 65536 // Stored as two-byte unsigned.
                        DotEquate.argument = DecArgument(value)
                    }
                    else {
                        DotEquate.argument = UnsignedDecArgument(value)
                    }
                    maps.symbolTable.insert(DotEquate.symbolDef, value)
                    maps.adjustSymbolValueForBurn.insert(DotEquate.symbolDef, false)
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Decimal constant is out of range (-32768..65535)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_HEX_CONSTANT) {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                var ok: Bool
                var value = tokenString.toInt(&ok, 16)
                if (value < 65536) {
                    DotEquate.argument = HexArgument(value)
                    maps.symbolTable.insert(DotEquate.symbolDef, value)
                    maps.adjustSymbolValueForBurn.insert(DotEquate.symbolDef, false)
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Hexidecimal constant is out of range (0x0000..0xFFFF)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_STRING_CONSTANT) {
                if (assembler.byteStringLength(str: tokenString) > 2) {
                    errorString = ";ERROR: .EQUATE string operand must have length at most two."
                    return false
                }
                DotEquate.argument = StringArgument(tokenString)
                maps.symbolTable.insert(DotEquate.symbolDef, assembler.string2ArgumentToInt(tokenString))
                maps.adjustSymbolValueForBurn.insert(DotEquate.symbolDef, false)
                state = ParseState.ps_CLOSE
            }
            else if (token == ELexicalToken.lt_CHAR_CONSTANT) {
                DotEquate.argument = CharArgument(tokenString)
                maps.symbolTable.insert(DotEquate.symbolDef, assembler.charStringToInt(tokenString))
                maps.adjustSymbolValueForBurn.insert(DotEquate.symbolDef, false)
                state = ParseState.ps_CLOSE
            }
            else {
                errorString = ";ERROR: .EQUATE requires a dec, hex, or string constant argument."
                return false
            }
            break
                
            case .ps_DOT_WORD:
                if (token == ELexicalToken.lt_CHAR_CONSTANT) {
                DotWord.argument = CharArgument(tokenString)
                maps.byteCount += 2
                state = ParseState.ps_CLOSE
            }
            else if (token == ELexicalToken.lt_DEC_CONSTANT) {
                var ok: Bool
                var value = tokenString.toInt(&ok, 10)
                if ((-32768 <= value) && (value < 65536)) {
                    
                    if (value < 0) {
                        value += 65536 // Stored as two-byte unsigned.
                        DotWord.argument = DecArgument(value)
                    }
                    else {
                        DotWord.argument = UnsignedDecArgument(value)
                    }
                    maps.byteCount += 2
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Decimal constant is out of range (-32768..65535)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_HEX_CONSTANT) {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                var ok: Bool
                var value = tokenString.toInt(&ok, 16)
                if (value < 65536) {
                    DotWord.argument = HexArgument(value)
                    maps.byteCount += 2
                    state = ParseState.ps_CLOSE
                }
                else {
                    errorString = ";ERROR: Hexidecimal constant is out of range (0x0000..0xFFFF)."
                    return false
                }
            }
            else if (token == ELexicalToken.lt_STRING_CONSTANT) {
                if (assembler.byteStringLength(tokenString) > 2) {
                    errorString = ";ERROR: .WORD string operands must have length at most two."
                    return false
                }
                DotWord.argument = StringArgument(tokenString)
                maps.byteCount += 2
                state = ParseState.ps_CLOSE
            }
            else {
                errorString = ";ERROR: .WORD requires a char, dec, hex, or string constant argument."
                return false
            }
            break
                
            case .ps_CLOSE:
                if (token == ELexicalToken.lt_EMPTY) {
                code.sourceCodeLine = lineNum
                state = ParseState.ps_FINISH
            }
            else if (token == ELexicalToken.lt_COMMENT) {
                code.comment = tokenString
                state = ParseState.ps_COMMENT
            }
            else {
                errorString = ";ERROR: Comment expected following instruction."
                return false
            }
            break
                
            case .ps_COMMENT:
                if (token == ELexicalToken.lt_EMPTY) {
                code.sourceCodeLine = lineNum
                state = ParseState.ps_FINISH
            }
            else {
                // This error should not occur, as all characters are allowed in comments.
                errorString = ";ERROR: Problem detected after comment."
                return false
            }
            break
                
            default:
                break
            }
        }
            while (state != ParseState.ps_FINISH)
        return true

    }
    
    
    
    
    
    

    
    // Pre: self.source is populated with code from a complete correct Pep/9 source program.
    // Post: self.object is populated with the object code, one byte per entry, and returned.
    // MARK: SUBJECT TO CHANGE
    func getObjectCode() -> [Int] {
        object.removeAll()
        for i in 0...source.count {
            source[i].appendObjectCode(objectCode: &object)
        }
        return object
    }
    
    // Pre: self.source is populated with code from a complete correct Pep/9 source program.
    // Post: self.listing is populated with the assembler listing.
    // Post: self.listingTrace is populated with the object code.
    // Post: self.hasCheckBox is populated with the checkBox list that specifies whether a trace line can have a break point.
    // Post: assemblerListing is returned.
    func getAssemblerListing() -> [String] {
        // PLACEHOLDER
        return [""]
    }
    
    // Pre: self.listingTrace is populated.
    // Post: self.listingTrace is returned.
    func getListingTrace() -> [String] {
        // PLACEHOLDER
        return [""]
    }
    
    // Pre: self.hasCheckBox is populated.
    // Post: self.hasCheckBox is returned.
    // func getHasCheckBox() . [Bool] {}
    
    // Instead of the above getHasCheckBox, we will be using trace tags to enable/disable lines of code
    // More on this can be found in 
    
    // Pre: self.source is populated with code from a complete correct Pep/9 source program.
    // Post: The memAddress field of each code object is incremented by addressDelta.
    func adjustSourceCode(addressDelta: Int) {
        
    }
    
    // Pre: self.object is populated with code from a complete correct Pep/9 OS source program.
    // Post: self.object is loaded into OS rom of pep.mem
    func installOS() {
        
    }
    
    // Post: the pep/9 operating system is installed into memory, and true is returned
    // If assembly fails, false is returned
    // This function should only be called on program startup once
    func installDefaultOS() -> Bool {
        // PLACEHOLDER
        return true
    }
    

    
    // MARK: - Initializer
    init() {
        
    }
    
    func stringToAddrMode(_ rawStr: String) -> EAddrMode {
        var str = rawStr
        if str.characters.first == "," {
            // remove the comma
            str.characters.removeFirst()
        }
        
        str = str.trimmed().uppercased()
        
        if (str == "I") { return .I }
        if (str == "D") { return .D }
        if (str == "N") { return .N }
        if (str == "S") { return .S }
        if (str == "SF") { return .SF }
        if (str == "X") { return .X }
        if (str == "SX") { return .SX }
        if (str == "SFX") { return .SFX }
        return .None
        
    }
    
    
    // MARK: - Parser
    
    /// Lexical tokens
    enum ELexicalToken {
        case lt_ADDRESSING_MODE
        case lt_CHAR_CONSTANT
        case lt_COMMENT
        case lt_DEC_CONSTANT
        case lt_DOT_COMMAND
        case lt_EMPTY
        case lt_HEX_CONSTANT
        case lt_IDENTIFIER
        case lt_STRING_CONSTANT
        case lt_SYMBOL_DEF
    }
    
    enum ParseState {
        case ps_ADDRESSING_MODE
        case ps_CLOSE
        case ps_COMMENT
        case ps_DOT_ADDRSS
        case ps_DOT_ALIGN
        case ps_DOT_ASCII
        case ps_DOT_BLOCK
        case ps_DOT_BURN
        case ps_DOT_BYTE
        case ps_DOT_END
        case ps_DOT_EQUATE
        case ps_DOT_WORD
        case ps_FINISH
        case ps_INSTRUCTION
        case ps_START
        case ps_STRING
        case ps_SYMBOL_DEF
    }
    

    

    
    
    
    
}

