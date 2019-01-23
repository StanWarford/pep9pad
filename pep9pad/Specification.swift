//
//  Specification.swift
//  pep9pad
//
//  Created by David Nicholas on 9/27/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation

protocol Specification{
    func testunitPost() -> Bool
    func setUnitPre() -> Bool
    func getSourceCode() -> String
}


class MemSpecification : Specification{
    var memAddress : Int
    var memValue : Int
    var numBytes : Int
    
    init(memoryAddress : Int, memoryValue : Int, numberBytes : Int){
        memAddress = memoryAddress
        memValue = memoryValue
        numBytes = numberBytes
    }
    
    func testunitPost() -> Bool {
        return true
    }
    
    func setUnitPre() -> Bool {
        return true
    }
    
    func getSourceCode() -> String {
        return "STILL NEED TO DO THIS"
    }
    
    
}
//class MemSpecification: public Specification {
//    public:
//    MemSpecification(int memoryAddress, int memoryValue, int numberBytes);
//    void setUnitPre(MainMemory *mainMemory, CpuPane *cpuPane);
//    bool testUnitPost(MainMemory *mainMemory, CpuPane *cpuPane, QString &errorString);
//    QString getSourceCode();
//    private:
//    int memAddress;
//    int memValue;
//    int numBytes;
//};

class RegSpecification : Specification {
    var regAddress : CPUEMnemonic
    var regValue : Int
    
    init(registerAddress : CPUEMnemonic, registerValue : Int){
        regAddress = registerAddress
        regValue = registerValue
    }
    
    func testunitPost() -> Bool {
        return true
    }
    
    func setUnitPre() -> Bool {
        return true
    }
    
    func getSourceCode() -> String {
        return "STILL NEED TO DO THIS"

    }
    
    
}

class StatusBitSpecification : Specification {

    var nzvcsAddress : CPUEMnemonic
    var nzvcsValue : Bool
    
    init(statusBitAddress : CPUEMnemonic , statusBitValue : Bool){
        nzvcsAddress = statusBitAddress
        nzvcsValue = statusBitValue
        
    }
    func testunitPost() -> Bool {
        return true
    }
    
    func setUnitPre() -> Bool {
        return true
    }
    
    func getSourceCode() -> String {
        return "STILL NEED TO DO THIS"
    }
    
}
//
//class StatusBitSpecification: public Specification {
//    public:
//    StatusBitSpecification(Enu::EMnemonic statusBitAddress, bool statusBitValue);
//    void setUnitPre(MainMemory *mainMemory, CpuPane *cpuPane);
//    bool testUnitPost(MainMemory *mainMemory, CpuPane *cpuPane, QString &errorString);
//    QString getSourceCode();
//    private:
//    Enu::EMnemonic nzvcsAddress;
//    bool nzvcsValue;
//};
