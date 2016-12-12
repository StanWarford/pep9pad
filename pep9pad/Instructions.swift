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
    override func appendObjectCode(objectCode: [Int]) {
        
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}

class NonUnaryInstruction: Code {
    private var mnemonic: EMnemonic!
    private var addressingMode: EAddrMode!
    private var argument: Argument!
    override init() {}
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
