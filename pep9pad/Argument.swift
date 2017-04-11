 //
//  Argument.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// The Argument protocol.  I did this rather than make a superclass
protocol Argument {
    /// Returns the Int value of this argument.  Will be overridden by subclasses.
    func getArgumentValue() -> Int
    /// Returns the String value of this argument.  Will be overridden by subclasses.
    func getArgumentString() -> String
}


// MARK: - "Subclasses" of Argument (conformers to the Argument protocol).
class CharArgument: Argument {
    internal var charValue: String = ""
    
    init(char: String) {
        charValue = char
    }
    
    func getArgumentValue() -> Int {
        return assembler.charStringToInt(str: charValue)
    }
    
    func getArgumentString() -> String {
        return charValue
    }
}



class DecArgument: Argument {
    internal var decValue: Int = -1
    
    init(dec: Int) {
        decValue = dec
    }
    
    func getArgumentValue() -> Int {
        return decValue
    }
    
    func getArgumentString() -> String {
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
    
    func getArgumentValue() -> Int {
        return decValue
    }
    
    func getArgumentString() -> String {
        return "\(decValue)"
    }
}



class HexArgument: Argument {
    internal var hexValue: Int = -1
    init(hex: Int) {
        hexValue = hex
    }
    
    
    func getArgumentValue() -> Int {
        return hexValue
    }
    
    func getArgumentString() -> String {
        return "0x\(hexValue.toHex4())"
}
}
    
    
class StringArgument: Argument {
    internal var stringValue: String = ""
    init(str: String) {
        self.stringValue = str
    }
    
    func getArgumentValue() -> Int {
        return assembler.string2ArgumentToInt(str: stringValue)
    }
    
    func getArgumentString() -> String {
        return stringValue
    }
}

    
    
class SymbolRefArgument: Argument {
    internal var symbolRefValue: String = ""
    init(symbolRef: String) {
        symbolRefValue = symbolRef
    }
    
    func getArgumentValue() -> Int {

        if (symbolRefValue == "charIn") {
            if (maps.symbolTable.arrayOfKeys() as! [String]).contains("charIn") {
                return maps.symbolTable[symbolRefValue]!
            } else {
                let a = machine.mem[maps.dotBurnArgument-7]
                let b = machine.mem[maps.dotBurnArgument-6] 
//                print("dotburn=\(maps.dotBurnArgument)")
//                var lilmem = machine.mem[maps.dotBurnArgument-20..<machine.mem.count]
//                var arr = "from \(maps.dotBurnArgument-20) to \(machine.mem.count):"
//                for i in lilmem {
//                    arr.append("\(i.toHex2()) ")
//                }
//                print(arr)
//                print("a=\(a)")
//                print("b=\(b)")
                return 256*a+b
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
    
    func getArgumentString() -> String {
        return symbolRefValue
    }
}

