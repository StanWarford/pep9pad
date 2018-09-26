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
}
//    if (Pep::cpuFeatures == OneByteDataBus) {
//        mnemonToDecControlMap.insert("MDRMUX", MDRMux); decControlToMnemonMap.insert(MDRMux,"MDRMUX");
//    }
//    else if (Pep::cpuFeatures == TwoByteDataBus){
//        mnemonToDecControlMap.insert("MARMUX", MARMux); decControlToMnemonMap.insert(MARMux,"MARMUX");
//        mnemonToDecControlMap.insert("MDROMUX", MDROMux); decControlToMnemonMap.insert(MDROMux,"MDROMUX");
//        mnemonToDecControlMap.insert("MDREMUX", MDREMux); decControlToMnemonMap.insert(MDREMux,"MDREMUX");
//        mnemonToDecControlMap.insert("EOMUX", EOMux); decControlToMnemonMap.insert(EOMux,"EOMUX");
//    }
//
//    memControlToMnemonMap.clear();                      mnemonToMemControlMap.clear();
//    memControlToMnemonMap.insert(MemWrite, "MemWrite"); mnemonToMemControlMap.insert("MEMWRITE", MemWrite);
//    memControlToMnemonMap.insert(MemRead, "MemRead");   mnemonToMemControlMap.insert("MEMREAD", MemRead);
//
//    clockControlToMnemonMap.clear();                    mnemonToClockControlMap.clear();
//    clockControlToMnemonMap.insert(LoadCk, "LoadCk");   mnemonToClockControlMap.insert("LOADCK", LoadCk);
//    clockControlToMnemonMap.insert(MARCk, "MARCk");     mnemonToClockControlMap.insert("MARCK", MARCk);
//    clockControlToMnemonMap.insert(SCk, "SCk");         mnemonToClockControlMap.insert("SCK", SCk);
//    clockControlToMnemonMap.insert(CCk, "CCk");         mnemonToClockControlMap.insert("CCK", CCk);
//    clockControlToMnemonMap.insert(VCk, "VCk");         mnemonToClockControlMap.insert("VCK", VCk);
//    clockControlToMnemonMap.insert(ZCk, "ZCk");         mnemonToClockControlMap.insert("ZCK", ZCk);
//    clockControlToMnemonMap.insert(NCk, "NCk");         mnemonToClockControlMap.insert("NCK", NCk);
//    if (Pep::cpuFeatures == OneByteDataBus) {
//        clockControlToMnemonMap.insert(MDRCk, "MDRCk");     mnemonToClockControlMap.insert("MDRCK", MDRCk);
//    }
//    else if (Pep::cpuFeatures == TwoByteDataBus){
//        clockControlToMnemonMap.insert(MDROCk, "MDROCk");     mnemonToClockControlMap.insert("MDROCK", MDROCk);
//        clockControlToMnemonMap.insert(MDRECk, "MDRECk");     mnemonToClockControlMap.insert("MDRECK", MDRECk);
//    }
//
//    specificationToMnemonMap.clear();                   mnemonToSpecificationMap.clear();
//    specificationToMnemonMap.insert(Pre, "UnitPre:");   mnemonToSpecificationMap.insert("UNITPRE:", Pre);
//    specificationToMnemonMap.insert(Post, "UnitPost:"); mnemonToSpecificationMap.insert("UNITPOST:", Post);
//
//    memSpecToMnemonMap.clear();                         mnemonToMemSpecMap.clear();
//    memSpecToMnemonMap.insert(Mem, "Mem");              mnemonToMemSpecMap.insert("MEM", Mem);
//
//    regSpecToMnemonMap.clear();                         mnemonToRegSpecMap.clear();
//    regSpecToMnemonMap.insert(A, "A");                  mnemonToRegSpecMap.insert("A", A);
//    regSpecToMnemonMap.insert(X, "X");                  mnemonToRegSpecMap.insert("X", X);
//    regSpecToMnemonMap.insert(SP, "SP");                mnemonToRegSpecMap.insert("SP", SP);
//    regSpecToMnemonMap.insert(PC, "PC");                mnemonToRegSpecMap.insert("PC", PC);
//    regSpecToMnemonMap.insert(IR, "IR");                mnemonToRegSpecMap.insert("IR", IR);
//    regSpecToMnemonMap.insert(T1, "T1");                mnemonToRegSpecMap.insert("T1", T1);
//    regSpecToMnemonMap.insert(T2, "T2");                mnemonToRegSpecMap.insert("T2", T2);
//    regSpecToMnemonMap.insert(T3, "T3");                mnemonToRegSpecMap.insert("T3", T3);
//    regSpecToMnemonMap.insert(T4, "T4");                mnemonToRegSpecMap.insert("T4", T4);
//    regSpecToMnemonMap.insert(T5, "T5");                mnemonToRegSpecMap.insert("T5", T5);
//    regSpecToMnemonMap.insert(T6, "T6");                mnemonToRegSpecMap.insert("T6", T6);
//    regSpecToMnemonMap.insert(MARA, "MARA");            mnemonToRegSpecMap.insert("MARA", MARA);
//    regSpecToMnemonMap.insert(MARB, "MARB");            mnemonToRegSpecMap.insert("MARB", MARB);
//    regSpecToMnemonMap.insert(MDR, "MDR");              mnemonToRegSpecMap.insert("MDR", MDR);
//
//    statusSpecToMnemonMap.clear();                      mnemonToStatusSpecMap.clear();
//    statusSpecToMnemonMap.insert(N, "N");               mnemonToStatusSpecMap.insert("N", N);
//    statusSpecToMnemonMap.insert(Z, "Z");               mnemonToStatusSpecMap.insert("Z", Z);
//    statusSpecToMnemonMap.insert(V, "V");               mnemonToStatusSpecMap.insert("V", V);
//    statusSpecToMnemonMap.insert(C, "C");               mnemonToStatusSpecMap.insert("C", C);
//    statusSpecToMnemonMap.insert(S, "S");               mnemonToStatusSpecMap.insert("S", S);
//}
