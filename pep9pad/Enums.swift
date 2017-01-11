//
//  Enu.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//



/// Instruction mnemonics
enum EMnemonic {
    case ADDA, ADDX, ADDSP, ANDA, ANDX, ASLA, ASLX, ASRA, ASRX
    case BR, BRC, BREQ, BRGE, BRGT, BRLE, BRLT, BRNE, BRV
    case CALL, CPBA, CPBX, CPWA, CPWX
    case DECI, DECO
    case HEXO
    case LDBA, LDBX, LDWA, LDWX
    case MOVAFLG, MOVFLGA, MOVSPA
    case NEGA, NEGX, NOP, NOP0, NOP1, NOTA, NOTX
    case ORA, ORX
    case RET, RETTR, ROLA, ROLX, RORA, RORX
    case STBA, STBX, STWA, STWX, STOP, STRO, SUBA, SUBX, SUBSP
}


/// Addressing modes for instructions
enum EAddrMode: Int {
    case None = 0
    case I = 1
    case D = 2
    case N = 4
    case S = 8
    case SF = 16
    case X = 32
    case SX = 64
    case SFX = 128
    case All = 255
}

/// Format for symbols
enum ESymbolFormat {
    case F_NONE
    case F_1C
    case F_1D
    case F_2D
    case F_1H
    case F_2H
}

/// States of execution.  This is unused in Pep9.
//enum EExecState {
//    case eStart
//    case eRun, eRunAwaitIO
//    case eDebugAwaitIO, eDebugAwaitClick, eDebugRunToBP, eDebugSingleStep
//}

/// Waiting states
enum EWaiting {
    case eRunWaiting
    case eDebugSSWaiting
    case eDebugResumeWaiting
}


enum CPURegisters {
    case nBit
    case zBit
    case vBit
    case cBit
    case accumulator
    case indexRegister
    case stackPointer
    case programCounter
    case instructionSpecifier
    case operandSpecifier
    case operand
}

enum CPUFormats {
    case bin
    case hex
    case mnemon
    case dec
}

