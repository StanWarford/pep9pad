//
//  NonExecutables.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

class CommentOnly: Code {
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        let str = "             \(comment)" // 13 spaces followed by the comment
        assemblerListing.append(str)
        listingTrace.append(str)
    }
}


class BlankLine: Code {
    override func appendObjectCode(objectCode: inout [Int]) {
        // Does not generate code
    }
    
    override func appendSourceLine(assemblerListing: inout [String], listingTrace: inout [String], hasCheckBox: [Bool]) {
        // Does not appear in the listing
    }
}
