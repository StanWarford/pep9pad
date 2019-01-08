//
//  OneByteSimulator.swift
//  pep9pad
//
//  Created by David Nicholas on 10/30/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation


class OneByteSimulator {
    

     //Data registers
     var registerBank : [UInt8]
     var memoryRegisters : [UInt8]
     var NZVCSbits : UInt8
     
     //Control Signals
    //var code : [CPUEMnemonic: UInt8]!
     var controlSignals : [UInt8]
     var clockSignals  : [Bool]
     
     //Error handling
     var hadDataError = false
     var errorMessage = ""
    
    init(){
        registerBank = [UInt8](repeating: 0, count: 32)
        memoryRegisters = [UInt8](repeating: 0, count: 6)
        controlSignals = [UInt8](repeating: 0, count: 20)
        clockSignals = [Bool](repeating: false, count: 10)
        NZVCSbits = 0
//        registerBank(32), memoryRegisters(6), controlSignals(20), clockSignals(10), hadDataError(false), emitEvents(true),  errorMessage(""),
//        isALUCacheValid(false), ALUHasOutputCache(false), ALUOutputCache(0), ALUStatusBitCache(0)
//        {
//            presetStaticRegisters();
//        }
        presetStaticRegisters()
    }

    
    //Enums
    
//    enum CPURegisters: UInt8 {
//        //Two byte registers
//        case A = 0; case X = 2; case SP = 4; case PC = 6; case OS = 9; case T2 = 12; case T3 = 14;
//        case T4 = 16; case T5 = 18; case T6 = 20; case M1 = 22; case M2 = 24; case M3 = 26;
//        case M4 = 28; case M5 = 30;
//        
//        //One byte registers
//        case IS = 8; case T1 = 11
//    }
    enum EMemoryRegisters {
        case MEM_MARA; case MEM_MARB; case MEM_MDR; case MEM_MDRO; case MEM_MDRE
    }
    
    enum EControlSignals {
        case MemRead; case MemWrite;
        case A; case B; case EOMux; case MARMux; case MARA; case MARB; case AMux; case ALU; case CSMux; case AndZ;
        case CMux; case C;
        case MDRMux; case MDROMux; case MDREMux; case MDR; case MDRE; case MDRO;
        case PValid;
    }
    enum EClockSignals{
        case NCk; case ZCk; case VCk; case CCk; case SCk; case MARCk; case LoadCk; case MDRCk; case MDROCk; case MDRECk;
        case PValidCk;
    }
    enum EStatusBit
    {
        case  STATUS_N; case STATUS_Z; case STATUS_V; case STATUS_C; case STATUS_S
    }
    
    //Access CPU Registers
    func getRegisterBankByte(registerNumber : UInt8) -> UInt8{
        return 1
    }
    func getRegisterBankWord(registerNumber : UInt8) -> UInt16{
        return 1
    }
    
//    func getRegisterBankByte(registerNumber : CPURegisters) -> UInt8{
//        return 1
//    }
//    func getRegisterBankWord(registerNumber : CPURegisters) -> UInt16{
//        return 1
//    }
    func getMemoryRegister(registerNumber : EMemoryRegisters) -> UInt8{
        return 1
    }
    
    //Access register and Memory Bus
    func valueOnABus(result : UInt8) -> Bool {
        return false
    }
    func valueOnBBus(result : UInt8) -> Bool {
            return false
    }
    func valueOnCBus(result : UInt8) -> Bool {
              return false
    }
    
    //Test for Signals and Registers
    func getControlSignals(controlSignal : EControlSignals)-> UInt8{
        return 1
    }
    
    func getClockSignals(_ : EClockSignals) -> Bool {
        return false
    }
    
    func getStatusBit(_ : EStatusBit) -> Bool{
        return false
    }
    
    func setSignalsFromMicrocode(line : MicroCode) -> Bool{
        return false
    }
    
    //void setEmitEvents(bool b);
    ///DON"T KNOW IF WE NEED THESE
    func hadErrorOnStep() -> Bool {
        return false
    }
    
    func getErrorMessage() -> String {
        return ""
    }
    
    //Information about CPU internals
    func aluFnIsUnary()-> Bool{
        return false
    }
    
    //Return true if AMux has output, and set result equal to the value of the output.
    //Works for one and two byte buses
    func getAMuxOutput(result : UInt8) -> Bool {
        return false
    }
    
    //Return  true if CSMux has an ouput, and set result equal to the output if present
    func calculateCSMuxOutput(result : Bool) -> Bool {
        return false
    }
    //Return if the ALU has an ouput, and set result & NZVC bits according to the ALU function
    func calculateALUOutput(result : UInt8, NZVC : UInt8) -> Bool {
        return false
    }
    
    func presetStaticRegisters(){
        registerBank[22] = 0x00
        registerBank[23] = 0x01
        registerBank[24] = 0x02
        registerBank[25] = 0x03
        registerBank[26] = 0x04
        registerBank[27] = 0x08
        registerBank[28] = 0xF0
        registerBank[29] = 0xF6
        registerBank[30] = 0xFE
        registerBank[31] = 0xFF
        
    }
    
}
