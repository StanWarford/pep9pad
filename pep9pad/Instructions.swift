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
        
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}

class NonUnaryInstruction: Code {
    private var mnemonic: EMnemonic!
    private var addressingMode: EAddrMode!
    private var argument: Argument!
    override init() {}
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        // Placeholder
        return true
    }
    
    override func processSymbolTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        // Placeholder
        return true
    }
}
