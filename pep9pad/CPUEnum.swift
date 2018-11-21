//
//  CPUEnum.swift
//  pep9pad
//
//  Created by David Nicholas on 9/26/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

enum EMask : UInt8 // For ALU function 15
    {
        case SMask = 0x10
        case NMask = 0x08
        case ZMask = 0x04
        case VMask = 0x02
        case CMask = 0x01
    }
    
    enum MainBusState {
        case None
        case MemReadFirstWait
        case MemReadSecondWait
        case MemReadReady
        case MemWriteFirstWait
        case MemWriteSecondWait
        case MemWriteReady
    }
    
    enum CPUEMnemonic {
        case MemRead
        case MemWrite
        case A
        case B
        case EOMux
        case MARMux
        case MARA
        case MARB
        case AMux
        case ALU
        case CSMux
        case AndZ
        case CMux
        case C
        case MDRMux
        case MDROMux
        case MDREMux
        case MDR
        case MDRE
        case MDRO
        case NCk
        case ZCk
        case VCk
        case CCk
        case SCk
        case MARCk
        case LoadCk
        case MDRCk
        case MDROCk
        case MDRECk
        case Pre
        case Post
        case Mem
        case Acc // For CPUVIEW only
        case X
        case SP
        case PC
        case IR
        case T1
        case T2
        case T3
        case T4
        case T5
        case T6
        case N
        case cBit // FOR CPUVIEW ONLY
        case Z
        case V
        case S
    }

