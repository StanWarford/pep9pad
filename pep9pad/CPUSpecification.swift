//
//  CPUSpecification.swift
//  pep9pad
//
//  Created by Josh Haug on 3/27/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

protocol Specification {
    func setUnitPre(mem: CPUMemory, cpu: CPU1ByteRenderer)
    func testUnitPost(mem: CPUMemory, cpu: CPU1ByteRenderer, str: String)
    func getSourceCode() -> String
}

class MemSpecification { //: Specification {
    var memAddress: Int = 0
    var memValue: Int = 0
    var numBytes: Int = 0

}


