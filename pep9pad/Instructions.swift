//
//  Instructions.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

class UnaryInstruction: Code {
    var mnemonic: EMnemonic!
    override init(){}
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            objectCode.append(maps.opCodeMap[mnemonic]!)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var codeStr: String = maps.opCodeMap[mnemonic]!.toHex2()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
        }
        var symbolStr = symbolDef
        if symbolStr.count > 0 {
            symbolStr.append(":")
        }
        let mnemonStr: String = maps.enumToMnemonMap[mnemonic]!
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(mnemonStr.padAfter(width: 8))
        lineStr.append("           " + comment)
        maps.memAddrssToAssemblerListing[memAddress] = assemblerListing.count
        maps.listingRowChecked[assemblerListing.count] = false
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(true)
    }
}

class NonUnaryInstruction: Code {
    var mnemonic: EMnemonic!
    var addressingMode: EAddrMode!
    var argument: Argument!
    override init() {}
    
    override func appendObjectCode(objectCode: inout [Int]) {
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
        var codeStr: String = temp.toHex2()
        var oprndNumStr: String = argument.getArgumentValue().toHex4()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
            oprndNumStr = "   "
        }
        var symbolStr: String = symbolDef
        if symbolStr.count > 0 {
            symbolStr.append(":")
        }
        let mnemonStr: String = maps.enumToMnemonMap[mnemonic]!
        var oprndStr: String = argument.getArgumentString()
        if maps.addrModeRequiredMap[mnemonic]! {
            oprndStr.append("," + maps.stringForAddrMode(addressMode: addressingMode))
        } else if addressingMode == EAddrMode.X {
            oprndStr.append("," + maps.stringForAddrMode(addressMode: addressingMode))
        }
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 2))
        lineStr.append(oprndNumStr.padAfter(width: 5))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(mnemonStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        maps.memAddrssToAssemblerListing[memAddress] = assemblerListing.count
        maps.listingRowChecked[assemblerListing.count] = false
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(true)
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        if mnemonic == EMnemonic.CALL && argument.getArgumentString() == "malloc" {
            if rxFormatTag.appearsIn(comment) {
                var list: [String] = []
                let formatTag: [String] = rxFormatTag.matchesIn(comment)
                let tagType: ESymbolFormat = assembler.formatTagType(formatTag: formatTag[0])
                let multiplier: Int = assembler.formatMultiplier(formatTag[0])
                let symbolDef: String = memAddress.toHex2()
                if !maps.equateSymbols.contains(symbolDef) {
                    // Limitation: only one dummy format per program
                    maps.equateSymbols.append(symbolDef)
                }
                maps.symbolFormat[symbolDef] = tagType  // Any duplicates have value replaced
                maps.symbolFormatMultiplier[symbolDef] = multiplier
                list.append(symbolDef)
                maps.symbolTraceList[memAddress] = list
            }
        }
        return true
    }
    
    override func processSymbolTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        if mnemonic == EMnemonic.ADDSP || mnemonic == EMnemonic.SUBSP {
            var numBytesAllocated: Int
            if addressingMode != EAddrMode.I {
                errorString = ";WARNING: Stack trace not possible unless immediate addressing is specified"
                sourceLine = sourceCodeLine
                return false
            }
            numBytesAllocated = argument.getArgumentValue()
            var list: [String] = []
            var numBytesListed: Int = 0
            let symbolTag: [String] = rxSymbolTag.matchesIn(comment)
            for (var symbol) in symbolTag {
                symbol.removeFirst()
                if !(maps.equateSymbols.contains(symbol)) {
                    errorString = ";WARNING: " + symbol + " not specified in .EQUATE"
                    sourceLine = sourceCodeLine
                    return false
                }
                numBytesListed += assembler.tagNumBytes(symbolFormat: maps.symbolFormat[symbol]!) * maps.symbolFormatMultiplier[symbol]!
                list.append(symbol)
            }
            if numBytesAllocated != numBytesListed {
                let message: String = (mnemonic == EMnemonic.ADDSP) ? "deallocated" : "allocated"
                errorString = ";WARNING Number of bytes " + message + " (" + numBytesAllocated.toHex2() + ") not equal to number of bytes listed in trace tag (" + numBytesAllocated.toHex2() + ")."
                sourceLine = sourceCodeLine
                return false
            }
            maps.symbolTraceList[memAddress] = list
            return true
        }
        else if mnemonic == EMnemonic.CALL && argument.getArgumentString() == "malloc" {
            var list: [String] = []
            let symbolTag: [String] = rxSymbolTag.matchesIn(comment)
            for (var symbol) in symbolTag {
                symbol.removeFirst()
                if !maps.equateSymbols.contains(symbol) && !maps.blockSymbols.contains(symbol) {
                    errorString = ";WARNING " + symbol + " not specified in .EQUATE."
                    sourceLine = sourceCodeLine
                    return false
                }
                list.append(symbol)
            }
            if !list.isEmpty {
                maps.symbolTraceList[memAddress] = list
            }
            return true
        } else {
            return true
        }
    }
}
