//
//  Dots.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation


class DotAddress: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}


class DotAlign: Code {
    
    private var argument: Argument!
    private var numBytesGenerated: Argument!
    
    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}



class DotAscii: Code {
    
    private var argument: Argument!

    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}



class DotBlock: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
    
    override func processFormatTraceTags(sourceLine: Int, errorString: String) -> Bool {
        // Placeholder
        return true
    }
    
    override func processSymbolTraceTags(sourceLine: Int, errorString: String) -> Bool {
        // Placeholder
        return true
    }
}


class DotBurn: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var symbolStr = symbolDef;
        if (symbolStr.characters.count > 0) {
            symbolStr.append(":")
        }
        var dotStr: String = ".BURN"
        var oprndStr: String = argument.getArgumentString()
        let lineStr: String = "test" // MARK: NEED TO UPDATE
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}

class DotByte: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            var objectCode = objectCode
            objectCode.append(argument.getArgumentValue())
        }
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var codeStr: String // MARK: NEED TO UPDATE
        if maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "  "
        }
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        var dotStr: String = ".BYTE"
        var oprndStr: String = argument.getArgumentString()
        if oprndStr.hasPrefix("0x") || oprndStr.hasPrefix("0X") {
            oprndStr = oprndStr.substring(from: oprndStr.index(oprndStr.endIndex, offsetBy: -2))
        }
        var lineStr: String = "test" // MARK: NEED TO UPDATE
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}

class DotEnd: Code {
    override func appendObjectCode(objectCode: [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var symbolStr: String = symbolDef
        if symbolStr.characters.count >  0 {
            symbolStr.append(":")
        }
        var dotStr = ".END"
        var lineStr: String = "test"
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
}


class DotEquate: Code {
    
    private var argument: Argument!
    
    override func appendObjectCode(objectCode: [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        var dotStr: String = ".EQUATE"
        var oprndStr: String = argument.getArgumentString()
        var lineStr: String = "TEST" // MARK: NEED TO UPDATE
        assembler.listing.append(lineStr)
        hasCheckBox.append(false)
    }
    
    override func processFormatTraceTags(sourceLine: Int, errorString: String) -> Bool {
        if symbolDef.isEmpty {
            return true
        }
        var pos: Int = assembler.rxFormatTag.index(ofAccessibilityElement: comment)
        if pos > -1 {
            // MARK: NEED TO DO
            // MARK: NEED TO DO
            // MARK: NEED TO DO
            maps.equateSymbols.append(symbolDef)
        }
        return true
    }
}


class DotWord: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        var objectCode = objectCode
        if maps.burnCount == 0 || (maps.burnCount == 1 && memAddress >= maps.romStartAddress) {
            var value: Int = argument.getArgumentValue()
            objectCode.append(value / 256)
            objectCode.append(value % 256)
        }
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        var listingTrace = listingTrace
        var hasCheckBox = hasCheckBox
        var memStr: String // MARK: NEED TO UPDATE
        var codeStr: String // MARK: NEED TO UPDATE
        if  maps.burnCount == 1 && memAddress < maps.romStartAddress {
            codeStr = "   "
        }
        var symbolStr: String = symbolDef
        if symbolStr.characters.count > 0 {
            symbolStr.append(":")
        }
        var dotStr: String = ".WORD"
        var oprndStr: String = argument.getArgumentString()
        var lineStr: String = "TEST" // MARK: NEED TO UPDATE
        assembler.listing.append(lineStr)
        listingTrace.append(lineStr)
        hasCheckBox.append(false)
    }
    
}
