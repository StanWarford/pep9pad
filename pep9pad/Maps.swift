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

var aluInstructionMap : [Int : String] = [
                                            0 : "A",
                                            1 : "A plus B",
                                            2 : "A plus B plus Cin",
                                            3 : "A plus B̅ plus 1",
                                            4 : "A  plus B̅ plus Cin",
                                            5 : "A・B",
                                            6 : "Need",
                                            7 : "A+B",
                                            8 : "Need",
                                            9 : "A⊕B",
                                            10 : "A̅",
                                            11 : "ASL A",
                                            12 : "ROL A",
                                            13 : "ASR A",
                                            14 : "ROR A",
                                            15 : "0"
                                        ]

func initEnumMnemonMaps(currentBusSize : CPUBusSize){
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
        if currentBusSize == .oneByte {
            mnemonToDecControlMap["MDRMUX"] = .MDRMux
            decControlToMnemonMap[.MDRMux] = "MDRMUX"
        }else {
            mnemonToDecControlMap["MARMUX"] = .MARMux
            mnemonToDecControlMap["MDROMUX"] = .MDROMux
            mnemonToDecControlMap["MDREMUX"] = .MDREMux
            mnemonToDecControlMap["EOMUX"] = .EOMux
            
            decControlToMnemonMap[.MARMux] = "MARMUX"
            decControlToMnemonMap[.MDROMux] = "MDROMUX"
            decControlToMnemonMap[.MDREMux] = "MDREMUX"
            decControlToMnemonMap[.EOMux] = "EOMUX"
                
        }
    
        memControlToMnemonMap.removeAll()
        mnemonToMemControlMap.removeAll()
    
        memControlToMnemonMap[.MemWrite] = "MemWrite"
        memControlToMnemonMap[.MemRead] =  "MemRead"
    
        mnemonToMemControlMap["MEMWRITE"] =  .MemWrite
        mnemonToMemControlMap["MEMREAD"] = .MemRead

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
    
        if currentBusSize == .oneByte{
            clockControlToMnemonMap[.MDRCk] = "MDRCk"
            mnemonToClockControlMap["MDRCK"] = .MDRCk
        } else {
            clockControlToMnemonMap[.MDROCk] = "MDROCk"
            clockControlToMnemonMap[.MDRECk] = "MDRECk"
            
            mnemonToClockControlMap["MDROCK"] =  .MDROCk
            mnemonToClockControlMap["MDRECK"] =  .MDRECk
        }

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


// For Register banks and stuff
var CPURegisters : [CPUEMnemonic : UInt8] = [
    .Acc : 0,
    .X : 2,
    .SP : 4,
    .PC : 6,
    // Present in any derivative of Pep9CPU
    .T2 : 12,
    .T3 : 14,
    .T4 : 16,
    .T5 : 18,
    .T6 : 20,
    // one byte register
    .T1 : 11,
    //three byte register
    .IR : 8
]

