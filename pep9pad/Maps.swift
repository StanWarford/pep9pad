//
//  Maps.swift
//  pep9pad
//
//  Created by David Nicholas on 9/26/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation

var decControlToMnemonMap: [CPUEMnemonic: String]=[:]
var memControlToMnemonMap: [CPUEMnemonic: String] = [:]
var clockControlToMnemonMap: [CPUEMnemonic: String] = [:]
var specificationToMnemonMap: [CPUEMnemonic: String] = [:]
var memSpecToMnemonMap: [CPUEMnemonic: String] = [:]
var regSpecToMnemonMap: [CPUEMnemonic: String] = [:]
var statusSpecToMnemonMap: [CPUEMnemonic: String] = [:]

var mnemonToDecControlMap: [String: CPUEMnemonic] = [:]
var mnemonToMemControlMap: [String: CPUEMnemonic] = [:]
var mnemonToClockControlMap: [String: CPUEMnemonic] = [:]
var mnemonToSpecificationMap: [String: CPUEMnemonic] = [:]
var mnemonToMemSpecMap: [String: CPUEMnemonic] = [:]
var mnemonToRegSpecMap: [String: CPUEMnemonic] = [:]
var mnemonToStatusSpecMap: [String: CPUEMnemonic] = [:]


func initEnumMnemonMaps(){
    mnemonToDecControlMap.removeAll()
    decControlToMnemonMap.removeAll()
    
    mnemonToDecControlMap = [
        "C" :  .C,
        "B" :  .B,
        "A" : .A,
        "ANDZ" : .AndZ,
        "AMUX" : .AMux,
        "CMUX": .CMux,
        "ALU": .ALU,
        "CSMUX": .CSMux
    ]
    
    decControlToMnemonMap = [
        .C : "C",
        .B : "B",
        .A : "A",
        .AndZ : "ANDZ",
        .AMux : "AMUX",
        .CMux : "CMUX",
        .ALU : "ALU",
        .CSMux : "CSMUX"
    ]
        //if (Pep::cpuFeatures == OneByteDataBus) {
            mnemonToDecControlMap["MDRMUX"] = .MDRMux
            decControlToMnemonMap[.MDRMux] = "MDRMUX"
        //}
    //    else if (Pep::cpuFeatures == TwoByteDataBus){
    //        mnemonToDecControlMap.insert("MARMUX", MARMux); decControlToMnemonMap.insert(MARMux,"MARMUX");
    //        mnemonToDecControlMap.insert("MDROMUX", MDROMux); decControlToMnemonMap.insert(MDROMux,"MDROMUX");
    //        mnemonToDecControlMap.insert("MDREMUX", MDREMux); decControlToMnemonMap.insert(MDREMux,"MDREMUX");
    //        mnemonToDecControlMap.insert("EOMUX", EOMux); decControlToMnemonMap.insert(EOMux,"EOMUX");
    //    }
    //
        memControlToMnemonMap.removeAll()
        mnemonToMemControlMap.removeAll()
    
        memControlToMnemonMap[.MemWrite] = "MemWrite"
        memControlToMnemonMap[.MemRead] =  "MemRead"
    
        mnemonToMemControlMap["MEMWRITE"] =  .MemWrite
        mnemonToMemControlMap["MEMREAD"] = .MemRead
    //
        clockControlToMnemonMap.removeAll()
        clockControlToMnemonMap[.LoadCk] = "LoadCk"
        clockControlToMnemonMap[.MARCk] = "MARCk"
        clockControlToMnemonMap[.SCk] = "SCk"
        clockControlToMnemonMap[.CCk] = "CCk"
        clockControlToMnemonMap[.VCk] = "VCk"
        clockControlToMnemonMap[.ZCk] = "ZCk"
        clockControlToMnemonMap[.NCk] = "NCk"
    
        mnemonToClockControlMap.removeAll()
        mnemonToClockControlMap["LOADCK"] = .LoadCk
        mnemonToClockControlMap["MARCK"] = .MARCk
        mnemonToClockControlMap["SCK"] = .SCk
        mnemonToClockControlMap["CCK"] = .CCk
        mnemonToClockControlMap["VCK"] = .VCk
        mnemonToClockControlMap["ZCK"] = .ZCk
        mnemonToClockControlMap["NCK"] = .NCk
    
    //    if (Pep::cpuFeatures == OneByteDataBus) {
        clockControlToMnemonMap[.MDRCk] = "MDRCk"
        mnemonToClockControlMap["MDRCK"] = .MDRCk
    //    }
    //    else if (Pep::cpuFeatures == TwoByteDataBus){
    //        clockControlToMnemonMap.insert(MDROCk, "MDROCk");     mnemonToClockControlMap.insert("MDROCK", MDROCk);
    //        clockControlToMnemonMap.insert(MDRECk, "MDRECk");     mnemonToClockControlMap.insert("MDRECK", MDRECk);
    //    }
    //
        specificationToMnemonMap.removeAll()
        specificationToMnemonMap[.Pre] = "UNITPRE:"
        specificationToMnemonMap[.Post] =  "UnitPost:"
    
        mnemonToSpecificationMap.removeAll()
        mnemonToSpecificationMap["UNITPRE:"] = .Pre
        mnemonToSpecificationMap["UNITPOST:"] =  .Post
    
        mnemonToMemSpecMap.removeAll()
        mnemonToMemSpecMap["MEM"] = .Mem
    
    
        memSpecToMnemonMap.removeAll()
        memSpecToMnemonMap[.Mem] = "Mem"
    
        regSpecToMnemonMap.removeAll()
        regSpecToMnemonMap[.A] = "A"
        regSpecToMnemonMap[.X] = "X"
        regSpecToMnemonMap[.SP] = "SP"
        regSpecToMnemonMap[.PC] = "PC"
        regSpecToMnemonMap[.IR] = "IR"
        regSpecToMnemonMap[.T1] = "T1"
        regSpecToMnemonMap[.T2] = "T2"
        regSpecToMnemonMap[.T3] = "T3"
        regSpecToMnemonMap[.T4] = "T4"
        regSpecToMnemonMap[.T5] = "T5"
        regSpecToMnemonMap[.T6] = "T6"
        regSpecToMnemonMap[.MARA] = "MARA"
        regSpecToMnemonMap[.MARB] = "MARB"
        regSpecToMnemonMap[.MDR] = "MDR"
    
    
        mnemonToRegSpecMap.removeAll()
        mnemonToRegSpecMap["A"] = .A
        mnemonToRegSpecMap["X"] = .X
        mnemonToRegSpecMap["SP"] = .SP
        mnemonToRegSpecMap["PC"] = .PC
        mnemonToRegSpecMap["IR"] = .IR
        mnemonToRegSpecMap["T1"] = .T1
        mnemonToRegSpecMap["T2"] = .T2
        mnemonToRegSpecMap["T3"] = .T3
        mnemonToRegSpecMap["T4"] = .T4
        mnemonToRegSpecMap["T5"] = .T5
        mnemonToRegSpecMap["T6"] = .T6
        mnemonToRegSpecMap["MARA"] = .MARA
        mnemonToRegSpecMap["MARB"] = .MARB
        mnemonToRegSpecMap["MDR"] = .MDR
    
        statusSpecToMnemonMap.removeAll()
        statusSpecToMnemonMap[.N] = "N"
        statusSpecToMnemonMap[.Z] = "Z"
        statusSpecToMnemonMap[.V] = "V"
        statusSpecToMnemonMap[.C] = "C"
        statusSpecToMnemonMap[.S] = "S"
    
    
        mnemonToStatusSpecMap.removeAll()
        mnemonToStatusSpecMap["N"] = .N
        mnemonToStatusSpecMap["Z"] = .Z
        mnemonToStatusSpecMap["V"] = .V
        mnemonToStatusSpecMap["C"] = .C
        mnemonToStatusSpecMap["S"] = .S

}

