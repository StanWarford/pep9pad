//
//  Dots.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation


class DotAddress: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}


class DotAlign: Code {
    
    private var argument: Argument!
    private var numBytesGenerated: Argument!
    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}



class DotAscii: Code {
    
    private var argument: Argument!

    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}



class DotBlock: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
    
    override func processFormatTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        // placeholder
        return true
    }
    
    override func processSymbolTraceTags(at sourceLine: inout Int, err errorString: inout String) -> Bool {
        // placeholder
        return true
    }
}


class DotBurn: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}

class DotByte: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}

class DotEnd: Code {
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}


class DotEquate: Code {
    
    private var argument: Argument!
    
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
}


class DotWord: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: inout [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
    
}
