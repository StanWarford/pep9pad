//
//  Code.swift
//  pep9pad
//
//  Created by Josh Haug on 11/16/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// The abstract code class.
class Code {
    
    private var memAddress: Int = 0
    private var sourceCodeLine: Int = 0
    private var symbolDef: String = ""
    private var comment: String = ""
    
    func appendObjectCode(objectCode: [Int]) {}
    func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {}
    func adjustMemAddress(addressDelta: Int) {
        memAddress += addressDelta
    }
    func processFormatTraceTags(sourceLine: Int, errorString: String) -> Bool {
        return true
    }
    func processSymbolTraceTags(sourceLine: Int, errorString: String) -> Bool {
        return true
    }
    
}
