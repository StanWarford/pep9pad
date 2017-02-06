//
//  AssemblerModel.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

var assembler = AssemblerModel()

/// The highest level of abstraction in Pep9Pad.
class AssemblerModel {
    
    // MARK: - Properties
    
    /// Parsed source code, an array of Code objects.
    var source: [Code] = []
    /// Parsed object code, an array of integers.
    var object: [Int] = []
    /// The listing generated from the most recent assembler call.
    var listing: [String] = []
    
    
    
    // MARK: - Methods
    // Pre: self.textView.text contains a Pep/9 source program.
    // Post: If the program assembles correctly, true is returned, and sourceCode is populated
    // with the code objects. Otherwise false is returned and codeList is partially populated.
    // Post: pep.symbolTable is populated with values not adjusted for .BURN.
    // Post: pep.byteCount is the byte count for the object code not adjusted for .BURN.
    // Post: pep.burnCount is the number of .BURN instructions encountered in the source program.
//    func assemble() -> Bool {
//        pep.burnCount = 0
//        
//        var sourceLine: String
//        var errorString: String
//        var sourceCodeList: [String]
//        var code: Code
//        var lineNum: Int = 0
//        var dotEndDetected: Bool = false
//        
//        //removeErrorMessages();
//        //Asm.listOfReferencedSymbols.removeAll()
//        //Asm::listOfReferencedSymbolLineNums.removeAll()
//        pep.memAddrssToAssemblerListing.removeAll()
//        pep.symbolTable.removeAll()
//        pep.adjustSymbolValueForBurn.removeAll()
//        pep.symbolFormat.removeAll()
//        pep.symbolFormatMultiplier.removeAll();
//        pep.symbolTraceList.removeAll() // Does this clear the lists within the map?
//        pep.globalStructSymbols.removeAll()
//        pep.blockSymbols.removeAll()
//        pep.equateSymbols.removeAll()
//        source.removeAll()
//        
//        sourceCodeList = projectModel.sourceStr.components(separatedBy: "\n")
//        pep.byteCount = 0
//        pep.burnCount = 0
//        
//        while (lineNum < sourceCodeList.count && !dotEndDetected) {
//            sourceLine = sourceCodeList[lineNum]
//            if (!Asm::processSourceLine(sourceLine, lineNum, code, errorString, dotEndDetected)) {
//                source[lineNum].comment.append(errorString)
//                return false
//            }
//            source.append(code)
//            lineNum += 1
//        }
//        
//        // check for existence of .END
//        if (!dotEndDetected) {
//            errorString = ";ERROR: Missing .END sentinel."
//            source[0].comment.append(errorString)
//            return false
//        }
//        
//        // check size of program
//        if (pep.byteCount > 65535) {
//            errorString = ";ERROR: Object code size too large to fit into memory."
//            source[0].comment.append(errorString)
//            return false
//        }
//        
//        // check for unused symbols
//        for (int i = 0; i < Asm::listOfReferencedSymbols.length(); i++) {
//            if (!pep.symbolTable.contains(Asm::listOfReferencedSymbols[i])
//                && !(Asm::listOfReferencedSymbols[i] == "charIn")
//                && !(Asm::listOfReferencedSymbols[i] == "charOut")) {
//                errorString = ";ERROR: Symbol " + Asm::listOfReferencedSymbols[i] + " is used but not defined.";
//                appendMessageInSourceCodePaneAt(Asm::listOfReferencedSymbolLineNums[i], errorString);
//                return false;
//            }
//        }
//        
//        
//        pep.traceTagWarning = false
//        for (int i = 0; i < codeList.size(); i++) {
//            if (!codeList[i]->processFormatTraceTags(lineNum, errorString)) {
//                appendMessageInSourceCodePaneAt(lineNum, errorString);
//                pep.traceTagWarning = true;
//            }
//        }
//        
//        
//        if (!pep.traceTagWarning && !(pep.blockSymbols.isEmpty() && pep.equateSymbols.isEmpty())) {
//            for (int i = 0; i < codeList.size(); i++) {
//                if (!codeList[i]->processSymbolTraceTags(lineNum, errorString)) {
//                    appendMessageInSourceCodePaneAt(lineNum, errorString);
//                    pep.traceTagWarning = true;
//                }
//            }
//        }
//        
//        
////            traceVC.setMemoryTrace()
////            listingVC.showListing()
//
//        return true
//
//        }
//
//    }
    
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
        if (firstChar == ";") {
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
    
    // Pre: self.source is populated with code from a complete correct Pep/9 source program.
    // Post: self.object is populated with the object code, one byte per entry, and returned.
    // MARK: SUBJECT TO CHANGE
    func getObjectCode() -> [Int] {
        object.removeAll()
        for i in 0...source.count {
            source[i].appendObjectCode(objectCode: object)
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
    // func getHasCheckBox() -> [Bool] {}
    
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
    
    
    // MARK: Regular expressions for lexical analysis
    // NOTE: the following variables use the `try!` modifier to force a pattern-matching attempt. `NSRegularExpression` throws an error if the pattern is invalid. Our patterns are fixed and thus will never `throw` an error.
    let rxAddrMode = try! NSRegularExpression(pattern: "^((,)(\\s*)(i|d|x|n|s(?![fx])|sx(?![f])|sf|sfx){1}){1}", options: [.caseInsensitive])
    let rxCharConst = try! NSRegularExpression(pattern: "^((\')(?![\'])(([^\'\\\\]){1}|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))(\'))", options: [.caseInsensitive])
    let rxComment = try! NSRegularExpression(pattern: "^((;{1})(.)*)", options: [.caseInsensitive])
    let rxDecConst = try! NSRegularExpression(pattern: "^((([+|-]{0,1})([0-9]+))|^(([1-9])([0-9]*)))", options: [.caseInsensitive])
    let rxDotCommand = try! NSRegularExpression(pattern: "^((.)(([A-Z|a-z]{1})(\\w)*))", options: [.caseInsensitive])
    let rxHexConst = try! NSRegularExpression(pattern: "^((0(?![x|X]))|((0)([x|X])([0-9|A-F|a-f])+)|((0)([0-9]+)))", options: [.caseInsensitive])
    let rxIdentifier = try! NSRegularExpression(pattern: "^((([A-Z|a-z|_]{1})(\\w*))(:){0,1})", options: [.caseInsensitive])
    let rxStringConst = try! NSRegularExpression(pattern: "^((\")((([^\"\\\\])|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))*)(\"))", options: [.caseInsensitive])
    
    // MARK: Regular expressions for trace tag analysis
    let rxFormatTag = try! NSRegularExpression(pattern: "(#((1c)|(1d)|(1h)|(2d)|(2h))((\\d)+a)?(\\s|$))", options: [.caseInsensitive])
    let rxSymbolTag = try! NSRegularExpression(pattern: "#([a-zA-Z][a-zA-Z0-9]{0,7})", options: [.caseInsensitive])
    let rxArrayMultiplier = try! NSRegularExpression(pattern: "((\\d)+)a", options: [.caseInsensitive])
    

    
    
    
    
}
