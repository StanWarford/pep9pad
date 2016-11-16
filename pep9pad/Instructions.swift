//
//  Instructions.swift
//  pep9pad
//
//  Created by Josh Haug on 11/16/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

class UnaryInstruction: Code {
    private var mnemonic: EMnemonic
    
    override func appendObjectCode(objectCode: [Int]) {
        
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        <#code#>
    }
}

class NonUnaryInstruction: Code {
    private var mnemonic: EMnemonic
    private var addressingMode: EAddrMode
    private var argument: Argument
    
    override func appendObjectCode(objectCode: [Int]) {
        <#code#>
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        <#code#>
    }
    
    override func processFormatTraceTags(sourceLine: Int, errorString: String) -> Bool {
        <#code#>
    }
    
    override func processSymbolTraceTags(sourceLine: Int, errorString: String) -> Bool {
        <#code#>
    }
}
