//
//  Enu.swift
//  pep9pad
//
//  Created by Josh Haug on 3/8/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//



/// Instruction mnemonics
enum EMnemonic {
    case adda, addx, addsp, anda, andx, asla, aslx, asra, asrx
    case br, brc, breq, brge, brgt, brle, brlt, brne, brv
    case call, cpba, cpbx, cpwa, cpwx
    case deci, deco
    case hexo
    case ldba, ldbx, ldwa, ldwx
    case movaflg, movflga, movspa
    case nega, negx, nop, nop0, nop1, nota, notx
    case ora, orx
    case ret, rettr, rola, rolx, rora, rorx
    case stba, stbx, stwa, stwx, stop, stro, suba, subx, subsp
}


/// Addressing modes for instructions
enum EAddrMode: Int {
    case none = 0
    case i = 1
    case d = 2
    case n = 4
    case s = 8
    case sf = 16
    case x = 32
    case sx = 64
    case sfx = 128
    case all = 255
}


/// Format for symbols
enum ESymbolFormat {
    case f_NONE
    case f_1C
    case f_1D
    case f_2D
    case f_1H
    case f_2H
}

// States of execution
enum EExecState {
    case eStart
    case eRun, eRunAwaitIO
    case eDebugAwaitIO, eDebugAwaitClick, eDebugRunToBP, eDebugSingleStep
}

/// Waiting states
enum EWaiting {
    case eRunWaiting
    case eDebugSSWaiting
    case eDebugResumeWaiting
}


// TODO: Update these if necesssary
enum EPane {
    case eSource
    case eObject
    case eListing
    case eListingTrace
    case eMemoryTrace
    case eBatchIO
    case eTerminal
}

