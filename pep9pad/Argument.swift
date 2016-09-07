//
//  Argument.swift
//  pep9pad
//
//  Created by Josh Haug on 3/8/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// The abstract Argument class.
class Argument {
    /// Returns the Int value of this argument.  Will be overridden by subclasses.
    func getArgumentValue() -> Int {
        return -1
    }
    
    /// Returns the String value of this argument.  Will be overridden by subclasses.
    func getArgumentString() -> String {
        return ""
    }
}


// MARK: - Concrete subclasses of Argument.
class CharArgument: Argument {
    internal var charValue: String = ""
    
    init(char: String) {
        charValue = char
    }
    
//    override func getArgumentValue() -> Int {
//        return charStringToInt(charValue)
//    }
    
    override func getArgumentString() -> String {
        return charValue
    }
}



class DecArgument: Argument {
    internal var decValue: Int = -1
    
    init(dec: Int) {
        decValue = dec
    }
    
    override func getArgumentValue() -> Int {
        return decValue
    }
    
    override func getArgumentString() -> String {
        if decValue >= 32768 {
            return "\(decValue - 65536)"
        }
        return "\(decValue)"
    }
}



class UnsignedDecArgument: Argument {
    internal var decValue: Int = -1
    init(dec: Int) {
        decValue = dec
    }
    
    override func getArgumentValue() -> Int {
        return decValue
    }
    
    override func getArgumentString() -> String {
        return "\(decValue)"
    }
}



class HexArgument: Argument {
    internal var hexValue: Int = -1
    init(hex: Int) {
        hexValue = hex
    }
    
    
    override func getArgumentValue() -> Int {
        return hexValue
    }
    
    override func getArgumentString() -> String {
        //return "0x" + QString("%1").arg(hexValue, 4, 16, QLatin1Char('0')).toUpper();
        return "TODO"
}

    
    
class StringArgument: Argument {
    internal var stringValue: String = ""
    init(str: String) {
        stringValue = str
    }
    
    override func getArgumentValue() -> Int {
        //return Asm::string2ArgumentToInt(stringValue);
        return -1
    }
    
    override func getArgumentString() -> String {
        return stringValue
    }
}
    
    
    
//class SymbolRefArgument: Argument {
//    internal var symbolRefValue: String = ""
//    init(symbolRef: String) {
//        symbolRefValue = symbolRef
//    }
//    
//    override func getArgumentValue() -> Int {
//        if (symbolRefValue == "charIn") {
//            return Pep::symbolTable.contains("charIn") ? Pep::symbolTable.value(symbolRefValue) : 256 * Sim::Mem[Pep::dotBurnArgument - 7] + Sim::Mem[Pep::dotBurnArgument - 6];
//        }
//        else if (symbolRefValue == "charOut") {
//            return Pep::symbolTable.contains("charOut") ? Pep::symbolTable.value(symbolRefValue) : 256 * Sim::Mem[Pep::dotBurnArgument - 5] + Sim::Mem[Pep::dotBurnArgument - 4];
//        }
//        else {
//            return Pep::symbolTable.value(symbolRefValue);
//        }
//    }
//    
//    override func getArgumentString() -> String {
//        return symbolRefValue
//    }
//}
}