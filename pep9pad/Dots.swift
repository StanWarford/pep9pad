//
//  Dots.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation


class DotAddress: Code {
    
    private var argument: Argument!
    
    
    override func appendObjectCode( objectCode:inout [Int]) {
        var objectCode = objectCode
        if maps.byteCount == 0 || (maps.byteCount == 1 && memAddress >= maps.romStartAddress) {
            var symbolValue: Int = maps.symbolTable[argument.getArgumentString()]!
            objectCode.append(symbolValue / 256)
            objectCode.append(symbolValue % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var hasCheckBox = hasCheckBox
        //QString memStr = QString("%1").arg(memAddress, 4, 16, QLatin1Char('0')).toUpper();
        var symbolValue: Int = maps.symbolTable[argument.getArgumentString()]!;
        //QString codeStr = QString("%1").arg(symbolValue, 4, 16, QLatin1Char('0')).toUpper();
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            //codeStr = "    ";
        }
        var symbolStr: String = symbolDef;
        if (symbolStr.length > 0) {
            symbolStr.append(":")
        }
        var dotStr: String = ".ADDRSS"
        var oprndStr: String = argument.getArgumentString();
        /*QString lineStr = QString("%1%2%3%4%5%6")
         .arg(memStr, -6, QLatin1Char(' '))
         .arg(codeStr, -7, QLatin1Char(' '))
         .arg(symbolStr, -9, QLatin1Char(' '))
         .arg(dotStr, -8, QLatin1Char(' '))
         .arg(oprndStr, -12)
         .arg(comment);*/
        //assembler.listing.append(lineStr);    MARK
        //listingTrace.append(lineStr);         MARK
        hasCheckBox.append(false);
        
    }
}


class DotAlign: Code {
    
    private var argument: Argument!
    private var numBytesGenerated: Argument!
    
    override func appendObjectCode(objectCode:inout [Int]) {
        var objectCode = objectCode
        if maps.byteCount == 0 || (maps.byteCount == 1 && memAddress >= maps.romStartAddress) {
            var symbolValue: Int = maps.symbolTable[argument.getArgumentString()]!
            objectCode.append(symbolValue / 256)
            objectCode.append(symbolValue % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing:inout [String], listingTrace:inout [String], hasCheckBox: [Bool]) {
        var assemblerListing = assemblerListing
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var numBytes: Int = numBytesGenerated.getArgumentValue()
        var memStr: String = "numBytes" //== 0 ? "       " :  MARK
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
        var dotStr: String = ".ALIGN"
        var oprndStr: String = argument.getArgumentString()
        var lineStr: String = ("")//.addingPercentEncoding(withAllowedCharacters: <#T##CharacterSet#>) MARK
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
            }
        }
    }
}



class DotAscii: Code {
    
    private var argument: Argument!
    
    override func appendObjectCode(objectCode:inout [Int]) {
        var objectCode = objectCode
        if maps.byteCount == 0 || (maps.byteCount == 1 && memAddress >= maps.romStartAddress) {
            var value: Int = 0   // MARK
            var str: String = argument.getArgumentString()
            str.remove(0, 1)
            str.chop()
            while str.length > 0 {
                //assembler.unquotedStringToInt(str, value) //MARK
                objectCode.append(value)
            }
        }
    }
    
    override func appendSourceLine(assemblerListing:inout [String], listingTrace:inout [String], hasCheckBox: [Bool]) {
        var assemblerListing = assemblerListing
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String = "" // MARK
        var str: String = argument.getArgumentString()
        str.remove(0, 1)
        str.chop()
        var value: Int
        var codeStr: String = ""
        while str.length < 0 && codeStr.length < 6 {
            // assembler.unquotedStringToInt(str, value)
            codeStr.append("") // MARK
        }
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "      "
        }
        var symbolStr: String = symbolDef
        if symbolStr.length > 0 {
            symbolStr.append(":")
        }
        var dotStr: String = ".ASCII"
        var oprndStr: String = argument.getArgumentString()
        var lineStr = "" // MARK
        assemblerListing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            while str.length > 0 {
                codeStr = ""
                while str.length > 0 && codeStr.length < 6 {
                    // assembler.unquotedStringToInt(str, value)
                    codeStr.append("")  //  MARK
                }
                lineStr = ("      %1")//    MARK
                assemblerListing.append(lineStr)
                listingTrace.append(lineStr)
                hasCheckBox.append(false)
            }
        }
    }
}



class DotBlock: Code {
    
    private var argument: Argument!
    
    
    override func appendObjectCode(objectCode:inout [Int]) {
        var objectCode = objectCode
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            for i in 0..<argument.getArgumentValue() {
                objectCode.append(0)
            }
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace:inout [String], hasCheckBox: [Bool]) {
        var assemblerListing = assemblerListing
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String = ("") // MARK
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
        var dotStr: String = ".BLOCK"
        var oprndStr: String = argument.getArgumentString()
        var lineStr:String = ("")   //   MARK
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
                lineStr = ("")  // MARK
                assemblerListing.append(lineStr)
                listingTrace.append(lineStr)
                hasCheckBox.append(false)
            }
        }
    }
    
    override func processFormatTraceTags(at sourceLine:inout Int, err errorString:inout String) -> Bool { // MARK
        /*if symbolDef.isEmpty {
            return true
        }
        //var pos: Int = assembler.rxFormatTag .index(ofAccessibilityElement: comment)
        if pos > -1 {
            var formatTag: String = assembler.rxFormatTag // MARK
            // var tagType: enum.ESymbolFormat = assembler.formatTag // MARK
            //var multiplier: Int = assembler.formatMultiplier*/
            return true
        //}
    }
    
    override func processSymbolTraceTags(at sourceLine:inout Int, err errorString:inout String) -> Bool {
        // Placeholder
        return true
    }
}


class DotBurn: Code {
    
    private var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var symbolStr = symbolDef;
        if (symbolStr.characters.count > 0) {
            symbolStr.append(":")
        }
        let dotStr: String = ".BURN"
        let oprndStr: String = argument.getArgumentString()
        var lineStr: String = memStr.stringFormatter(str: " ", fixLength: 6)
        lineStr.append(symbolStr.stringFormatter(str: " ", fixLength: 9))
        lineStr.append(dotStr.stringFormatter(str: " ", fixLength:  8))
        lineStr.append(oprndStr.stringFormatter(str: "", fixLength: 12))
        lineStr.append(comment)
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}


class DotByte: Code {
    
    private var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            var objectCode = objectCode
            objectCode.append(argument.getArgumentValue())
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
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
        var lineStr: String = memStr.stringFormatter(str: " ", fixLength: 6)
        lineStr.append(codeStr.stringFormatter(str: " ", fixLength: 7))
        lineStr.append(symbolStr.stringFormatter(str: " ", fixLength: 9))
        lineStr.append(dotStr.stringFormatter(str: " ", fixLength: 8))
        lineStr.append(oprndStr.stringFormatter(str: "", fixLength: 12))
        lineStr.append(comment)
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}

class DotEnd: Code {
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        let memStr: String = memAddress.toHex4()
        var symbolStr: String = symbolDef
        if symbolStr.characters.count >  0 {
            symbolStr.append(":")
        }
        let dotStr = ".END"
        var lineStr: String = memStr.stringFormatter(str: " ", fixLength: 6)
        lineStr.append(symbolStr.stringFormatter(str: " ", fixLength: 9))
        lineStr.append(dotStr.stringFormatter(str: " ", fixLength: 8))
        lineStr.append(comment)
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}


class DotEquate: Code {
    
    private var argument: Argument!
    
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
        var lineStr: String = symbolStr.stringFormatter(str: " ", fixLength: 9)
        lineStr.append(dotStr.stringFormatter(str: " ", fixLength: 8))
        lineStr.append(oprndStr.stringFormatter(str: "", fixLength: 12))
        lineStr.append(comment)
        assembler.listing.append(lineStr)
        hasCheckBox.append(false)
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        return true
    }
}


class DotWord: Code {
    
    private var argument: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        var objectCode = objectCode
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            let value: Int = argument.getArgumentValue()
            objectCode.append(value / 256)
            objectCode.append(value % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
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
        var lineStr: String = memStr.stringFormatter(str: " ", fixLength: 6)
        lineStr.append(codeStr.stringFormatter(str: " ", fixLength: 7))
        lineStr.append(symbolStr.stringFormatter(str: " ", fixLength: 9))
        lineStr.append(dotStr.stringFormatter(str: " ", fixLength: 8))
        lineStr.append(oprndStr.stringFormatter(str: "", fixLength: 12))
        lineStr.append(comment)
        
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}
