//
//  Code.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// Abstract class.  Each instance of this class represents one line of parsed assembly code.
/// These are subclassed in Instructions.swift, Dots.swift, and NonExecutables.swift.
class Code {
    
    internal var memAddress: Int = 0
    internal var sourceCodeLine: Int = 0
    internal var symbolDef: String = ""
    internal var comment: String = ""
    
    func appendObjectCode(objectCode: inout [Int]) {}
    
    func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {}
    
    func adjustMemAddress(addressDelta: Int) {
        memAddress += addressDelta
    }
    
    func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        return true
    }
    
    func processSymbolTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        return true
    }
    
}
