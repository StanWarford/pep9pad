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
    /// Note that this corresponds to `listOfReferencedSymbols` in the .cpp file.
    var referencedSymbols: [String] = []
    ///
    var referencedSymbolsLineNums: [Int] = []
    
    func processSourceLine(_ sourceLine: String, _ code: Code, _ errorString: String) -> Bool {
        //PLACEHOLDER
    }
    
    
    
    // MARK: - Methods
    // Pre: self.textView.text contains a Pep/9 source program.
    // Post: If the program assembles correctly, true is returned, and sourceCode is populated
    // with the code objects. Otherwise false is returned and codeList is partially populated.
    // Post: pep.symbolTable is populated with values not adjusted for .BURN.
    // Post: pep.byteCount is the byte count for the object code not adjusted for .BURN.
    // Post: pep.burnCount is the number of .BURN instructions encountered in the source program.
    func assemble() -> Bool {
        maps.burnCount = 0
        
        var sourceLine: String
        var errorString: String
        var sourceCodeList: [String]
        var code: Code
        var lineNum: Int = 0
        var dotEndDetected: Bool = false
        
        //removeErrorMessages();
        referencedSymbols.removeAll()
        referencedSymbolsLineNums.removeAll()
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
            if (!processSourceLine(sourceLine, lineNum, code, errorString, dotEndDetected)) {
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
            if (!maps.symbolTable.contains(where: referencedSymbols[i])
                && !(referencedSymbols[i] == "charIn")
                && !(referencedSymbols[i] == "charOut")) {
                errorString = ";ERROR: Symbol " + referencedSymbols[i] + " is used but not defined.";
                //appendMessageInSourceCodePaneAt(referencedSymbolsLineNums[i], errorString);
                return false;
            }
        }
        
        
        maps.traceTagWarning = false
        // TODO: difference between size() and length()?
        for (int i = 0; i < codeList.size(); i++) {
            if (!codeList[i].processFormatTraceTags(lineNum, errorString)) {
                appendMessageInSourceCodePaneAt(lineNum, errorString);
                pep.traceTagWarning = true;
            }
        }
        
        
        if (!pep.traceTagWarning && !(pep.blockSymbols.isEmpty() && pep.equateSymbols.isEmpty())) {
            for (int i = 0; i < codeList.size(); i++) {
                if (!codeList[i]->processSymbolTraceTags(lineNum, errorString)) {
                    appendMessageInSourceCodePaneAt(lineNum, errorString);
                    pep.traceTagWarning = true;
                }
            }
        }
        
        
//            traceVC.setMemoryTrace()
//            listingVC.showListing()

        return true

        }

    }

    // Pre: self.source is populated with code from a complete correct Pep/9 source program.
    // Post: self.object is populated with the object code, one byte per entry, and returned.
    func getObjectCode() -> [Int] {
        // PLACEHOLDER
        return [0]
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
    func adjustSourceCode(_ addressDelta: Int) {
        
    }
    
    // Pre: self.object is populated with code from a complete correct Pep/9 OS source program.
    // Post: self.object is loaded into OS rom of pep.mem
    func installOS() {
        
    }
    
    // Post: the pep/9 operating system is installed into memory, and true is returned
    // If assembly fails, false is returned
    // This function should only be called on program startup once
    func installDefaultOS() -> Bool {
        var sourceLine: String
        var errorString: String
        var sourceCodeList: [String]
        var code: Code
        var lineNum = 0
        var dotEndDetected = false
        
        assembler.referencedSymbols = []
        maps.memAddrssToAssemblerListing = [:]
        maps.symbolTable = [:]
        maps.adjustSymbolValueForBurn = [:]
        while (assembler.source.count != 0) {
            assembler.source.remove(at: 0)
        }
        var sourceCode: String = ""
        let pathToSource = Bundle.main.path(forResource: "pep9os", ofType: "pep")
        do {
            print("Loaded file named pep9os.pep")
            sourceCode = try String(contentsOfFile:pathToSource!, encoding: String.Encoding.ascii)
        } catch _ as NSError {
            print("Could not load file named pep9os.pep")
            return false
        }
        sourceCodeList = sourceCode.components(separatedBy: "\n")
        maps.byteCount = 0
        maps.burnCount = 0
        while (lineNum < sourceCodeList.count && !dotEndDetected) {
            sourceLine = sourceCodeList[lineNum]
            if !assembler.processSourceLine(sourceLine, code, errorString) {
                return false
            }
            assembler.source.append(code)
            lineNum = lineNum + 1
        }
        if !dotEndDetected {
            return false
        }
        if maps.byteCount > 65535 {
            return false
        }
        for i in 0..<assembler.referencedSymbols.count {
            if !Array(maps.symbolTable.keys).contains(assembler.referencedSymbols[i]) {
                return false
            }
        }
        if maps.burnCount != 1 {
            return false
        }
        
        //Adjust for .BURN
        
        var addressDelta: Int = maps.dotBurnArgument - maps.burnCount + 1
        var symbolTableSize: Int = maps.symbolTable.count
        for (kind, numbers) in maps.symbolTable {
            var valueAtCurrentKey: Bool = maps.adjustSymbolValueForBurn[kind]!
            if valueAtCurrentKey {
                maps.symbolTable[kind] = maps.symbolTable[kind]! + addressDelta
            }
        }
        adjustSourceCode(addressDelta)
        maps.romStartAddress = maps.romStartAddress + addressDelta
        getObjectCode()
        installOS()
        
        return true
    }
    

    
    // MARK: - Initializer
    init() {
        
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
