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
    override func appendObjectCode(objectCode: inout [Int]) {
        var objectCode = objectCode
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            objectCode.append(maps.opCodeMap[mnemonic]!)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String = memAddress.toHex4()
        var codeStr: String = maps.opCodeMap[mnemonic]!.toHex4()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
        }
        var symbolStr = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        var mnemonStr: String = maps.enumToMnemonMap[mnemonic]!
        var lineStr: String = "test"
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
    
    override func appendObjectCode(objectCode: inout [Int]) {
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
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var temp: Int // MARK: NEED TO DO
        // temp += maps.addrModeRequiredMap.values ? maps.aaaAddressField(addressMode: addressingMode) : maps.aAddressField(addressMode: addressingMode)
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
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        return true
    }
    
//    override func processSymbolTraceTags(sourceLine: Int, errorString: String) -> Bool {
//        var sourceLine = sourceLine
//        var errorString = errorString
//        if mnemonic == EMnemonic.ADDSP || mnemonic == EMnemonic.SUBSP {
//            var numBytesAllocated: Int
//            if addressingMode != EAddrMode.I {
//                errorString = ";WARNING: Stack trace not possible unless immediate addressing is specified"
//                sourceLine = sourceCodeLine
//                return false
//            }
//            //numBytesAllocated = argument.getArgumentString()
//            var symbol: String
//            var list: [String]
//            var numBytesListed: Int = 0
//            var pos: Int = 0
//            while (pos = assembler.rxSymbolTag.indexIn(comment, pos)) != -1 {
//                symbol = assembler.rxSymbolTag.cap(1)
//                if !maps.equateSymbols.contains(symbol) {
//                    errorString = ";WARNING: " + symbol + " not specified in .EQUATE."
//                    sourceLine = sourceCodeLine
//                    return false
//                }
//                numBytesListed += assembler.tagNumBytes(maps.symbolFormat.values) * maps.symbolFormatMultiplier.values
//                list.append(symbol)
//                pos += assembler.rxSymbolTag.matchedLength()
//            }
//            if numBytesAllocated != numBytesListed {
//                var message: String = (mnemonic == EMnemonic.ADDSP) ? "deallocated" : "allocated"
//                errorString = // TODO
//                // TODO
//                return false
//            }
//            // TODO
//            return true
//        }
//        else if mnemonic == EMnemonic.CALL && argument.getArgumentString() == "malloc" {
//            var pos: Int = 0
//            var symbol: String
//            var list: [String]
//            // MARK: ALL CODE BELOW TODO
//        }
//    }
}
