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

class MemSpecification: Specification {
    var memAddress: Int = 0
    var memValue: Int = 0
    var numBytes: Int = 0
    
    internal func getSourceCode() -> String {
        return ""
    }

    internal func testUnitPost(mem: CPUMemory, cpu: CPU1ByteRenderer, str: String) {
        
    }

    internal func setUnitPre(mem: CPUMemory, cpu: CPU1ByteRenderer) {
        
    }

}

class RegSpecification: Specification {
    var regAddress: CPUMnemonic = .LoadCk // Enu::EMnemonic regAddress;
    var regValue: Int = 0;
    
    internal func getSourceCode() -> String {
        return ""
    }
    
    internal func testUnitPost(mem: CPUMemory, cpu: CPU1ByteRenderer, str: String) {
        
    }
    
    internal func setUnitPre(mem: CPUMemory, cpu: CPU1ByteRenderer) {
        
    }
    
}

class StatusBitSpecification: Specification {
    var nzvcsAddress: CPUMnemonic = .LoadCk // Enu::EMnemonic nzvcsAddress;
    var nzvcsValue: Bool = false;
    
    internal func getSourceCode() -> String {
        return ""
    }
    
    internal func testUnitPost(mem: CPUMemory, cpu: CPU1ByteRenderer, str: String) {
        
    }
    
    internal func setUnitPre(mem: CPUMemory, cpu: CPU1ByteRenderer) {
        
    }
    
}
