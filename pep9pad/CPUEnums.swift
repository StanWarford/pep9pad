//
//  CPUEnums.swift
//  pep9pad
//
//  Created by Stan Warford on 3/23/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

enum ALUMask: Int // For ALU function 15
{
    case NMask = 0x08
    case ZMask = 0x04
    case VMask = 0x02
    case CMask = 0x01
}

enum CPUMainBusState {
    case None
    case MemReadFirstWait
    case MemReadSecondWait
    case MemReadReady
    case MemWriteFirstWait
    case MemWriteSecondWait
    case MemWriteReady
}

enum CPUMnemonic {
    case LoadCk, C, B, A, MARCk, MDRCk, AMux, MARMux, MDRMux, MDROMux, MDREMux, EOMux, CMux
    case MDROCk, MDRECk, ALU, CSMux, SCk, CCk, VCk, AndZ, ZCk, NCk, MemWrite, MemRead
    case Mem, X, SP, PC, IR, T1, T2, T3, T4, T5, T6, N, Z, V, S
    case MARA, MARB, MDR, MDRE, MDRO
    case Pre, Post
};

enum CPUType {
    case OneByteDataBus
    case TwoByteDataBus
}

