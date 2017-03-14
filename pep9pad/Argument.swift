//
//  Argument.swift
//  pep9pad
//
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

    
    
class SymbolRefArgument: Argument {
    internal var symbolRefValue: String = ""
    init(symbolRef: String) {
        symbolRefValue = symbolRef
    }
    
    override func getArgumentValue() -> Int {

        if (symbolRefValue == "charIn") {
            if (maps.symbolTable.arrayOfKeys() as! [String]).contains("charIn") {
                return maps.symbolTable[symbolRefValue]!
            } else {
                return 256 * machine.mem[maps.dotBurnArgument-7] + machine.mem[maps.dotBurnArgument-6]
            }
        }
        else if (symbolRefValue == "charOut") {
            
            if (maps.symbolTable.arrayOfKeys() as! [String]).contains("charOut") {
                return maps.symbolTable[symbolRefValue]!
            } else {
                return 256 * machine.mem[maps.dotBurnArgument-5] + machine.mem[maps.dotBurnArgument-4]
            }

        }
        else {
            return maps.symbolTable[symbolRefValue]!
        }
    }
    
    override func getArgumentString() -> String {
        return symbolRefValue
    }
}

