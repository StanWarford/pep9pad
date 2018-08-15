//
//  Dots.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation


class DotAddress: Code {
    
    var argument: Argument!
    
    
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            let symbolValue: Int = maps.symbolTable[argument.getArgumentString()]!
            objectCode.append(symbolValue / 256)
            objectCode.append(symbolValue % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        let symbolValue: Int = maps.symbolTable[argument.getArgumentString()]!;
        var codeStr: String = symbolValue.toHex4()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "    "
        }
        var symbolStr: String = symbolDef
        if (symbolStr.length > 0) {
            symbolStr.append(":")
        }
        let dotStr: String = ".ADDRSS"
        let oprndStr: String = argument.getArgumentString();
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
        
    }
}


class DotAlign: Code {
    
    var argument: Argument!
    var numBytesGenerated: Argument!
    
    override func appendObjectCode(objectCode:inout [Int]) {
        if maps.byteCount == 0 || (maps.byteCount == 1 && memAddress >= maps.romStartAddress) {
            let symbolValue: Int = maps.symbolTable[argument.getArgumentString()]!
            objectCode.append(symbolValue / 256)
            objectCode.append(symbolValue % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing:inout [String], listingTrace:inout [String], hasCheckBox: [Bool]) {
//        var assemblerListing = assemblerListing
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var numBytes: Int = numBytesGenerated.getArgumentValue()
        let memStr: String = numBytes == 0 ? "       " : memAddress.toHex4()
        var codeStr: String = ""
        while numBytes > 0 && codeStr.length < 6 {
            codeStr.append("00")
            numBytes = numBytes - 1
        }
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "       "
        }
        var symbolStr: String = symbolDef
        if symbolStr.length > 0 {
            symbolStr.append(":")
        }
        let dotStr: String = ".ALIGN"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            while numBytes > 0 {
                codeStr = ""
                while numBytes > 0 && codeStr.length < 6 {
                    codeStr.append("00")
                    numBytes = numBytes - 1
                }
                lineStr = codeStr.padAfter(width: 7)
                assemblerListing.append(lineStr)
                listingTrace.append(lineStr)
                hasCheckBox.append(false)
            }
        }
    }
}



class DotAscii: Code {
    
    var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            var value: Int = 0   // MARK
            var str: String = argument.getArgumentString()
            str.remove(0, 1) // remove the first double quote char
            str.chop() // remove the last double quote char
            while str.length > 0 {
                assembler.unquotedStringToInt(str: &str, value: &value)
                objectCode.append(value)
            }
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
//        var assemblerListing = assemblerListing
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var str: String = argument.getArgumentString()
        str.remove(0, 1)
        str.chop()
        var value: Int = 0
        var codeStr: String = ""
        while str.length > 0 && codeStr.length < 6 {
            assembler.unquotedStringToInt(str: &str, value: &value)
            codeStr.append(value.toHex2())
        }
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "      "
        }
        var symbolStr: String = symbolDef
        if symbolStr.length > 0 {
            symbolStr.append(":")
        }
        let dotStr: String = ".ASCII"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.length > 12 ? oprndStr : oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            while str.length > 0 {
                codeStr = ""
                while str.length > 0 && codeStr.length < 6 {
                    assembler.unquotedStringToInt(str: &str, value: &value)
                    codeStr.append(value.toHex2())
                }
                lineStr = "      \(codeStr)"
                assemblerListing.append(lineStr)
                listingTrace.append(lineStr)
                hasCheckBox.append(false)
            }
        }
    }
}



class DotBlock: Code {
    
    var argument: Argument!
    
    
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            for _ in 0..<argument.getArgumentValue() {
                objectCode.append(0)
            }
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
//        var assemblerListing = assemblerListing
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = (memAddress.toHex4())
        var numBytes: Int = argument.getArgumentValue()
        var codeStr: String = ""
        while numBytes > 0 && codeStr.length < 6  {
            codeStr.append("00")
            numBytes = numBytes - 1
        }
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "       "
        }
        var symbolStr: String = symbolDef
        if symbolStr.length > 0 {
            symbolStr.append(":")
        }
        let dotStr: String = ".BLOCK"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            while numBytes > 0 {
                codeStr = ""
                while numBytes > 0 && codeStr.length < 6 {
                    codeStr.append("00")
                    numBytes = numBytes - 1
                }
                lineStr = (codeStr.padAfter(width: 7))
                assemblerListing.append(lineStr)
                listingTrace.append(lineStr)
                hasCheckBox.append(false)
            }
        }
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool { // MARK
        if symbolDef.isEmpty {
            return true
        }
        if rxFormatTag.appearsIn(comment) {
            let formatTag: [String] = rxFormatTag.matchesIn(comment) //Array of Trace Tags
            //let formatTag: string = rxFormatTag.cap(0)
            let tagType: ESymbolFormat = assembler.formatTagType(formatTag: formatTag[0])
            let multiplier: Int = assembler.formatMultiplier(formatTag[0])
            if argument.getArgumentValue() != (assembler.tagNumBytes(symbolFormat: tagType) * multiplier) {
                errorString = ";WARNING: Format tag does not match number of bytes allocated by .BLOCK."
                sourceLine = sourceCodeLine
                return false
            }
            maps.symbolFormat[symbolDef] = tagType
            maps.symbolFormatMultiplier[symbolDef] = multiplier
            maps.blockSymbols.append(symbolDef)
        }
        return true
    }
    
    override func processSymbolTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        if symbolDef.isEmpty {
            return true
        }
        if maps.blockSymbols.contains(symbolDef) {
            return true // Pre-Existing format tag takes precedence over symbol tag.
        }
        
        let numBytesAllocated: Int = argument.getArgumentValue()
        var symbol: String
        let symbolTag: [String] = rxSymbolTag.matchesIn(comment)
        var list: [String] = []
        var numBytesListed: Int = 0
        for (var symbol) in symbolTag {
            symbol.removeFirst() // remove the # at the beginning
            if !(maps.equateSymbols.contains(symbol)) {
                errorString = ";WARNING: " + symbol + " not specified in .EQUATE"
                sourceLine = sourceCodeLine
                return false
            }
            numBytesListed += assembler.tagNumBytes(symbolFormat: maps.symbolFormat[symbol]!) * maps.symbolFormatMultiplier[symbol]!
            list.append(symbol)
        }
        if (numBytesAllocated != numBytesListed) && (numBytesListed > 0) {
            errorString = ";WARNING: Number of bytes allocated (" //+  UPDATE
            sourceLine = sourceCodeLine
            return false
        }
        maps.blockSymbols.append(symbolDef)
        maps.globalStructSymbols.updateValue(list, forKey: symbolDef) // UPDATE
        return true
    }
}


class DotBurn: Code {
    
    var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var symbolStr = symbolDef;
        if (symbolStr.characters.count > 0) {
            symbolStr.append(":")
        }
        let dotStr: String = ".BURN"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}


class DotByte: Code {
    
    var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            objectCode.append(argument.getArgumentValue())
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var codeStr: String = argument.getArgumentValue().toHex4()
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
        }
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        let dotStr: String = ".BYTE"
        var oprndStr: String = argument.getArgumentString()
        if oprndStr.hasPrefix("0x") || oprndStr.hasPrefix("0X") {
            oprndStr = oprndStr.substring(from: oprndStr.index(oprndStr.endIndex, offsetBy: -2))
        }
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}

class DotEnd: Code {
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var symbolStr: String = symbolDef
        if symbolStr.characters.count >  0 {
            symbolStr.append(":")
        }
        let dotStr = ".END"
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append("       ")
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}


class DotEquate: Code {
    
    var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var hasCheckBox = hasCheckBox
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        let dotStr: String = ".EQUATE"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = "             "
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        assemblerListing.append(lineStr)
        hasCheckBox.append(false)
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        if symbolDef.isEmpty {
            return true
        }
        if rxFormatTag.appearsIn(comment) {
            let formatTag: [String] = rxFormatTag.matchesIn(comment) //Array of Trace Tags
            let tagType: ESymbolFormat = assembler.formatTagType(formatTag: formatTag[0])
            let multiplier: Int = assembler.formatMultiplier(formatTag[0])
            maps.symbolFormat[symbolDef] = tagType
            maps.symbolFormatMultiplier[symbolDef] = multiplier
            maps.equateSymbols.append(symbolDef)
            print(maps.equateSymbols)
        }
        return true
        }
    }



class DotWord: Code {
    
    var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            let value: Int = argument.getArgumentValue()
            objectCode.append(value / 256)
            objectCode.append(value % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
//        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var codeStr: String = argument.getArgumentValue().toHex4()
        if  maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "   "
        }
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        let dotStr: String = ".WORD"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = memStr.padAfter(width: 6)
        lineStr.append(codeStr.padAfter(width: 7))
        lineStr.append(symbolStr.padAfter(width: 9))
        lineStr.append(dotStr.padAfter(width: 8))
        lineStr.append(oprndStr.padAfter(width: 12))
        lineStr.append(comment)
        
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}
