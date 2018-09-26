//
//  CPUCode.swift
//  pep9pad
//
//  Created by Josh Haug on 2/13/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

protocol CPUCode {
    func isMicrocode() -> Bool
    //func setCpuLabels(items: inout CpuGraphicsItems)
    func getObjectCode() -> String
    func getSourceCode() -> String
    func hasUnitPre() -> Bool
    //func setUnitPre(mem: inout MainMemory, cpu: inout CPUPane)
    //func testPostCondition(mem: inout MainMemory, )
}


// Concrete code classes
// Code is the union of the elements of the one-byte bus model and two-byte bus model
class MicroCode: CPUCode {
    func isMicrocode() -> Bool {
        return false
    }
    
    func getObjectCode() -> String {
        return " "
    }
    
    func getSourceCode() -> String {
        return " "
    }
    
    func hasUnitPre() -> Bool {
        return false
    }
}

class CommentOnlyCode:  CPUCode
{
    func isMicrocode() -> Bool {
        return false
    }
    
    func getObjectCode() -> String {
        return " "
    }
    
    func getSourceCode() -> String {
        return " "
    }
    
    func hasUnitPre() -> Bool {
        return false
    }
}

class UnitPostCode: CPUCode
{
    func isMicrocode() -> Bool {
        return false
    }
    
    func getObjectCode() -> String {
        return " "
    }
    
    func getSourceCode() -> String {
        return " "
    }
    
    func hasUnitPre() -> Bool {
        return false
    }
}

class UnitPreCode: CPUCode
{
    func isMicrocode() -> Bool {
        return false
    }
    
    func getObjectCode() -> String {
        return " "
    }
    
    func getSourceCode() -> String {
        return " "
    }
    
    func hasUnitPre() -> Bool {
        return false
    }
}

class BlankLineCode: CPUCode
{
    func isMicrocode() -> Bool {
        return false
    }
    
    func getObjectCode() -> String {
        return " "
    }
    
    func getSourceCode() -> String {
        return " "
    }
    
    func hasUnitPre() -> Bool {
        return false
    }
}


