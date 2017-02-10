//
//  Instructions.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

class UnaryInstruction: Code {
    private var mnemonic: EMnemonic!
    override init(){}
    override func appendObjectCode(objectCode: [Int]) {
        
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var codeStr: String // MARK: NEED TO UPDATE
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
        }
        var symbolStr = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        // MARKL NEED TO DO
        var lineStr: String = "Test" // MARK: NEED TO UPDATE
        // MARK: NEED TO DO
        // MARK: NEED TO DO
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(true)
    }
}

class NonUnaryInstruction: Code {
    private var mnemonic: EMnemonic!
    private var addressingMode: EAddrMode!
    private var argument: Argument!
    override init() {}
    
    override func appendObjectCode(objectCode: [Int]) {
        var objectCode = objectCode
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            var instructionSpecifier = maps.opCodeMap.values
            // MARK: TO BE CONTINUED
        }
        // MARK: NEED TO DO
        var operandSpecifier = argument.getArgumentValue()
        objectCode.append(operandSpecifier / 256)
        objectCode.append(operandSpecifier % 256)
        
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var temp: Int // MARK: NEED TO DO
        temp += maps.addrModeRequiredMap.values ? maps.aaaAddressField(addressMode: addressingMode) : maps.aAddressField(addressMode: addressingMode)
        var codeStr: String // MARK: NEED TO UPDATE
        var oprndNumStr: String // MARK: NEED TO UPDATE
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
            oprndNumStr = "   "
        }
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        var mnemonStr: String // MARK: NEED TO UPDATE
        var oprndStr: String = argument.getArgumentString()
        // MARK: NEED TO DO THIS
        var lineStr: String = "TEST" // MARK: NEED TO UPDATE
        // MARK: NEED TO DO THIS
        // MARK: NEED TO DO THIS
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(true)
    }
    
    override func processFormatTraceTags(sourceLine: Int, errorString: String) -> Bool {
        var pos: Int = assembler.rxFormatTag.index(ofAccessibilityElement: comment)
        if pos > -1 {
            var list: String
            // MARK: NEED TO DO THIS
            // TO BE CONTINUED
        }
        return true
    }
    
    override func processSymbolTraceTags(sourceLine: Int, errorString: String) -> Bool {
        // Placeholder
        return true
    }
}
