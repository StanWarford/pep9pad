//
//  ASM_Model.swift
//  pep9pad
//
//  Created by Josh Haug on 11/26/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

var model = ASM_Model()

/// The highest level of abstraction in Pep9Pad.
class ASM_Model {
    
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
    func assemble() -> Bool {
        pep.burnCount = 0
        
        var sourceLine: String
        var errorString: String
        var sourceCodeList: [String]
        var code: Code
        var lineNum: Int = 0
        var dotEndDetected: Bool = false
        
        //removeErrorMessages();
        //Asm.listOfReferencedSymbols.removeAll()
        //Asm::listOfReferencedSymbolLineNums.removeAll()
        pep.memAddrssToAssemblerListing.removeAll()
        pep.symbolTable.removeAll()
        pep.adjustSymbolValueForBurn.removeAll()
        pep.symbolFormat.removeAll()
        pep.symbolFormatMultiplier.removeAll();
        pep.symbolTraceList.removeAll() // Does this clear the lists within the map?
        pep.globalStructSymbols.removeAll()
        pep.blockSymbols.removeAll()
        pep.equateSymbols.removeAll()
        source.removeAll()
        
        sourceCodeList = projectModel.sourceStr.components(separatedBy: "\n")
        pep.byteCount = 0
        pep.burnCount = 0
        
        while (lineNum < sourceCodeList.count && !dotEndDetected) {
            sourceLine = sourceCodeList[lineNum]
            if (!Asm::processSourceLine(sourceLine, lineNum, code, errorString, dotEndDetected)) {
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
        if (pep.byteCount > 65535) {
            errorString = ";ERROR: Object code size too large to fit into memory."
            source[0].comment.append(errorString)
            return false
        }
        
        // check for unused symbols
        for (int i = 0; i < Asm::listOfReferencedSymbols.length(); i++) {
            if (!pep.symbolTable.contains(Asm::listOfReferencedSymbols[i])
                && !(Asm::listOfReferencedSymbols[i] == "charIn")
                && !(Asm::listOfReferencedSymbols[i] == "charOut")) {
                errorString = ";ERROR: Symbol " + Asm::listOfReferencedSymbols[i] + " is used but not defined.";
                appendMessageInSourceCodePaneAt(Asm::listOfReferencedSymbolLineNums[i], errorString);
                return false;
            }
        }
        
        
        pep.traceTagWarning = false
        for (int i = 0; i < codeList.size(); i++) {
            if (!codeList[i]->processFormatTraceTags(lineNum, errorString)) {
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
    func getHasCheckBox() -> [Bool] {
        // PLACEHOLDER
        return [true]
    }
    
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
    
}
