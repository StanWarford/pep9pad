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
    
    var mnemonicMap : [CPUEMnemonic:Int] = [:]
    var cComment : String
    
    init(){
        for memLines in 0..<memControlToMnemonMap.keys.count{
            mnemonicMap[memControlToMnemonMap.arrayOfKeys()[memLines] as! CPUEMnemonic] = -1
        }
        for mainCtrlLines in 0..<decControlToMnemonMap.keys.count{
            mnemonicMap[decControlToMnemonMap.arrayOfKeys()[mainCtrlLines] as! CPUEMnemonic] = -1
        }
        for clockLines in 0..<clockControlToMnemonMap.keys.count{
            mnemonicMap[clockControlToMnemonMap.arrayOfKeys()[clockLines] as! CPUEMnemonic] = -1
        }
        cComment = ""
    }
    
    func isMicrocode() -> Bool {
        return true
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
    func set(field : CPUEMnemonic , value : Int) {
        mnemonicMap[field]=value
    }

    
}

class CommentOnlyCode:  CPUCode
{
    
    var cComment : String
    
    init(comment: String){
        cComment = comment
    }
    
    func isMicrocode() -> Bool {
        return false
    }
    
    func getObjectCode() -> String {
        return " "
    }
    
    func getSourceCode() -> String {
        return cComment
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


