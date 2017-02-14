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
        let memStr: String = memAddress.toHex4()
        var codeStr: String = maps.opCodeMap[mnemonic]!.toHex4()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
        }
        var symbolStr = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        let mnemonStr: String = maps.enumToMnemonMap[mnemonic]!
        var lineStr: String = memStr.stringFormatter(str: " ", fixLength: 6)
        lineStr.append(codeStr.stringFormatter(str: " ", fixLength: 7))
        lineStr.append(symbolStr.stringFormatter(str: " ", fixLength: 9))
        lineStr.append(mnemonStr.stringFormatter(str: " ", fixLength: 8))
        lineStr.append("           " + comment)
        maps.memAddrssToAssemblerListing[memAddress] = assemblerListing.count
        maps.listingRowChecked[assemblerListing.count] = false
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
            var instructionSpecifier = maps.opCodeMap[mnemonic]
            if maps.addrModeRequiredMap[mnemonic]! {
                instructionSpecifier = instructionSpecifier! + maps.aaaAddressField(addressMode: addressingMode)
            } else {
                instructionSpecifier = instructionSpecifier! +  maps.aAddressField(addressMode: addressingMode)
            }
            objectCode.append(instructionSpecifier!)
            let operandSpecifier = argument.getArgumentValue()
            objectCode.append(operandSpecifier / 256)
            objectCode.append(operandSpecifier % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var temp: Int = maps.opCodeMap[mnemonic]!
        temp += maps.addrModeRequiredMap[mnemonic]! ? maps.aaaAddressField(addressMode: addressingMode) : maps.aAddressField(addressMode: addressingMode)
        var codeStr: String = temp.toHex4()
        var oprndNumStr: String = argument.getArgumentValue().toHex4()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
            oprndNumStr = "   "
        }
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        let mnemonStr: String = maps.enumToMnemonMap[mnemonic]!
        var oprndStr: String = argument.getArgumentString()
        if maps.addrModeRequiredMap[mnemonic]! {
            oprndStr.append("," + maps.stringForAddrMode(addressMode: addressingMode))
        } else if addressingMode == EAddrMode.X {
            oprndStr.append("," + maps.stringForAddrMode(addressMode: addressingMode))
        }
        var lineStr: String = memStr.stringFormatter(str: " ", fixLength: 6)
        lineStr.append(codeStr.stringFormatter(str: "", fixLength: 2))
        lineStr.append(oprndNumStr.stringFormatter(str: " ", fixLength: 5))
        lineStr.append(symbolStr.stringFormatter(str: " ", fixLength: 9))
        lineStr.append(mnemonStr.stringFormatter(str: " ", fixLength: 8))
        lineStr.append(oprndStr.stringFormatter(str: "", fixLength: 12))
        lineStr.append(comment)
        maps.memAddrssToAssemblerListing[memAddress] = assemblerListing.count
        maps.listingRowChecked[assemblerListing.count] = false
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(true)
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        if mnemonic == EMnemonic.CALL && argument.getArgumentString() == "malloc" {
            // MARK: TODO
        }
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
