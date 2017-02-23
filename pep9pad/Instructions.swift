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
    var mnemonic: EMnemonic!
    private var addressingMode: EAddrMode!
    var argument: Argument!
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
            let pos: Int = rxFormatTag.index(ofAccessibilityElement: comment)
            if pos > -1 {
                var list: [String] = [""]
                var formatTag: String = rxFormatTag.cap(section: 0)
                // MARK: NEED TO WRITE FUNCTIONS FOR THESE
                //var tagType: ESymbolFormat = formatTag
                //var multiplier: Int = formatTag
                var symbolDef: String = memAddress.toHex2()
                if !maps.equateSymbols.contains(symbolDef) {
                    // Limitation: only one dummy format per program
                    maps.equateSymbols.append(symbolDef)
                }
                // MARK: NEED TO FIND OR MAKE REALATED tagType & multiplier
                // maps.symbolFormat[symbolDef] = tagType
                //maps.symbolFormatMultiplier[symbolDef] = multiplier
                list.append(symbolDef)
                maps.symbolTraceList[memAddress] = list
            }
        }
        return true
    }
    
    override func processSymbolTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        var sourceLine = sourceLine
        var errorString = errorString
        if mnemonic == EMnemonic.ADDSP || mnemonic == EMnemonic.SUBSP {
            var numBytesAllocated: Int
            if addressingMode != EAddrMode.I {
                errorString = ";WARNING: Stack trace not possible unless immediate addressing is specified"
                sourceLine = sourceCodeLine
                return false
            }
            numBytesAllocated = argument.getArgumentValue()
            var symbol: String
            var list: [String]
            var numBytesListed: Int = 0
            var pos: Int = 0
            while pos == rxSymbolTag.index(ofAccessibilityElement: comment) != -1 { // MARK: TODO
                symbol = rxSymbolTag.cap(section: 1)
                if !maps.equateSymbols.contains(symbol) {
                    errorString = ";WARNING: " + symbol + " not specified in .EQUATE."
                    sourceLine = sourceCodeLine
                    return false
                }
                numBytesListed += tagNumBytes(maps.symbolFormat[symbol] * maps.symbolFormatMultiplier[symbol]) // MARK: TODO
                list.append(symbol)
                pos += rxSymbolTag.matchedLength() // MARK: TODO
            }
            if numBytesAllocated != numBytesListed {
                var message: String = (mnemonic == EMnemonic.ADDSP) ? "deallocated" : "allocated"
                errorString = ";WARNING Number of bytes " + message + " (" + numBytesAllocated.toHex2() + ") not equal to number of bytes listed in trace tag (" + numBytesAllocated.toHex2() + ")."
                sourceLine = sourceCodeLine
                return false
            }
            maps.symbolTraceList.insert(memAddress, list) // MARK: TODO
            return true
        }
        else if mnemonic == EMnemonic.CALL && argument.getArgumentString() == "malloc" {
            var pos: Int = 0
            var symbol: String
            var list: [String]
            while pos = rxSymbolTag.indexIn(comment, pos) != -1 {
                symbol = rxSymbolTag.cap(section: 1)
                if !maps.equateSymbols.contains(symbol) && !maps.blockSymbols.contains(symbol) {
                    errorString = ";WARNING " + symbol + " not specified in .EQUATE."
                    sourceLine = sourceCodeLine
                    return false
                }
                list.append(symbol)
                pos += rxSymbolTag.matchedLength() // MARK: TODO
            }
            if !list.isEmpty {
                maps.symbolTraceList.insert(memAddress, list) // MARK: TODO
            }
            return true
        } else {
            return true
        }
    }
}
