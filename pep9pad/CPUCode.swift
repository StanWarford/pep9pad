//
//  CPUCode.swift
//  pep9pad
//
//  Created by Josh Haug on 2/13/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

class CPUCode {
    func isMicrocode() -> Bool { return false }
    //    func setCpuLabels(items: inout CpuGraphicsItems) {}
    func getSourceCode() -> String { return "" }
    func hasUnitPre() -> Bool { return false }
    //    func setUnitPre(mem: inout MainMemory, cpu: inout CPUPane) {}
    //    func testPostCondition(mem: inout MainMemory, )
}

// Concrete CPUCode classes

// Microcode is the union of the elements of the one-byte bus model and two-byte bus model
// Elements not in the current model are simply not used.
// -1 is initialization value, - tested elsewhere

class Microcode: CPUCode {
    
    var cLoadCk: Int = -1
    var cC: Int = -1
    var cB: Int = -1
    var cA: Int = -1
    var cMARMux: Int = -1 // Two-byte model only
    var cMARCk: Int = -1
    var cMDRCk: Int = -1 // One-byte model only
    var cMDROCk: Int = -1 // Two-byte model only
    var cMDRECk: Int = -1 // Two-byte model only
    var cAMux: Int = -1
    var cMDRMux: Int = -1 // One-byte model only
    var cMDROMux: Int = -1 // Two-byte model only
    var cMDREMux: Int = -1 // Two-byte model only
    var cEOMux: Int = -1 // Two-byte model only
    var cCMux: Int = -1
    var cALU: Int = -1
    var cCSMux: Int = -1
    var cSCk: Int = -1
    var cCCk: Int = -1
    var cVCk: Int = -1
    var cAndZ: Int = -1
    var cZCk: Int = -1
    var cNCk: Int = -1
    var cMemWrite: Int = -1
    var cMemRead: Int = -1
    var cComment: String = ""
    
    // friend class Asm;
    // public:
    // MicroCode();
    // bool isMicrocode();
    // void setCpuLabels(CpuGraphicsItems *cpuPaneItems);
    
    //    func QString getSourceCode() -> String {
    //
    //    }
    
    
    // func has(Enu::EMnemonic field) -> Bool
    
    // void set(Enu::EMnemonic field, int value);
    
    // bool inRange(Enu::EMnemonic field, int value);
    
}

class CommentOnlyCode: CPUCode {
    //public:
    //CommentOnlyCode(QString comment);
    //QString getSourceCode();
    //private:
    //QString cComment;
}

class UnitPreCode: CPUCode {
    //public:
    //~UnitPreCode();
    //QString getSourceCode();
    //bool hasUnitPre();
    //void setUnitPre(MainMemory *mainMemory, CpuPane *cpuPane);
    //void appendSpecification(Specification *specification);
    //void setComment(QString comment);
    //private:
    //QList<Specification *> unitPreList;
    //QString cComment;
}

class UnitPostCode: Code {
    //public:
    //~UnitPostCode();
    //QString getSourceCode();
    //bool testPostcondition(MainMemory *mainMemory, CpuPane *cpuPane, QString &errorString);
    //void appendSpecification(Specification *specification);
    //void setComment(QString comment);
    //private:
    //QList<Specification *> unitPostList;
    //QString cComment;
}

class BlankLineCode: Code {
    
}
