//
//  Dots.swift
//  pep9pad
//
//  Created by Josh Haug on 11/19/16.
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
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}

class DotByte: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}

class DotEnd: Code {
    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
}


class DotEquate: Code {
    
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
}


class DotWord: Code {
    
    private var argument: Argument!

    
    override func appendObjectCode(objectCode: [Int]) {
        // Placeholder
    }
    
    override func appendSourceLine(assemblerListing: [String], listingTrace: [String], hasCheckBox: [Bool]) {
        // Placeholder
    }
    
}
