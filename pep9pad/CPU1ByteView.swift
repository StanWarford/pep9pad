//
//  CPU1ByteView.swift
//  pep9pad
//
//  Created by Stan Warford on 2/20/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

@IBDesignable
class CPU1ByteView: CPUView{
        
    var thisRect: CGRect!
    var codeList : [CPUCode]!
    var cycleCount = 0
    var codeIndex = 0
    var codeLine = 0
    var memoryView : MemoryView!
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.busSize = .oneByte
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.busSize = .oneByte
    }
    
    // MARK: - Drawing -
    override func draw(_ rect: CGRect) {
        thisRect = rect
        // Need to do this, otherwise the background will default to black.
        UIColor.white.setFill()
        UIRectFill(rect)
        CPU1ByteRenderer.drawIpad()
    }
    
    func updateCPU(line: CPUEMnemonic, value: String){
        let emptyValue = value == ""
        let intValue = Int(value)
        
        switch (line){
        case .LoadCk:
             CPU1ByteRenderer.loadCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
             CPU1ByteRenderer.loadCkText = value == "1" ? "✓" : value
        case .C:
            CPU1ByteRenderer.cLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.cBusColor = emptyValue ? UIColor.CPUColors.noFillColor : CPU1ByteRenderer.cMuxColor
            CPU1ByteRenderer.cText = value
            
            if CPU1ByteRenderer.mdrMuxText == "1"{
                CPU1ByteRenderer.mDRMuxColor = CPU1ByteRenderer.cBusColor
                CPU1ByteRenderer.mDRMuxOutArrowColor = CPU1ByteRenderer.mDRMuxColor
            }
            
        case .B:
            CPU1ByteRenderer.bLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.bBusColor = emptyValue ? UIColor.CPUColors.noFillColor : UIColor.CPUColors.bBusColor
            CPU1ByteRenderer.bText = value
            
        case .A:
            CPU1ByteRenderer.aLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.aBusColor = emptyValue ? UIColor.CPUColors.noFillColor : UIColor.CPUColors.aBusColor
            CPU1ByteRenderer.aText = value
            
            if CPU1ByteRenderer.aMuxText == "1"{
                CPU1ByteRenderer.aMuxColor = CPU1ByteRenderer.aBusColor
                CPU1ByteRenderer.aMuxOutArrow = CPU1ByteRenderer.aMuxColor
            }
        case .MARCk:
            CPU1ByteRenderer.mARCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.MARCkText = value == "1" ? "✓" : value
            
        case .MDRCk:
            CPU1ByteRenderer.mDRCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.MDRCkText = value == "1" ? "✓" : value
            
        case .AMux:
            //AMux
            CPU1ByteRenderer.aMuxLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.aMuxColor = emptyValue ? UIColor.CPUColors.noFillColor : intValue == 1 ? CPU1ByteRenderer.aBusColor : UIColor.CPUColors.mdrOutColor
            CPU1ByteRenderer.aMuxOutArrow = CPU1ByteRenderer.aMuxColor
            CPU1ByteRenderer.aMuxText = value
            
        case .MDRMux:
            CPU1ByteRenderer.mDRMuxLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.mDRMuxColor = emptyValue ? UIColor.CPUColors.noFillColor : intValue == 1 ? CPU1ByteRenderer.cBusColor : CPU1ByteRenderer.addrBusColor
            CPU1ByteRenderer.mDRMuxOutArrowColor = CPU1ByteRenderer.mDRMuxColor
            CPU1ByteRenderer.mdrMuxText = value
            
        case .CMux:
            //CMux
            CPU1ByteRenderer.cMuxLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.cMuxColor = emptyValue ? UIColor.CPUColors.noFillColor : intValue == 1 ? CPU1ByteRenderer.aLUOutArrowColor : CPU1ByteRenderer.cMuxLeftColor
            CPU1ByteRenderer.cMuxText = value
            
            //CBus
            CPU1ByteRenderer.cBusColor = CPU1ByteRenderer.cMuxColor
            
            //MDRMux
            if CPU1ByteRenderer.mdrMuxText == "1"{
                CPU1ByteRenderer.mDRMuxColor = CPU1ByteRenderer.cBusColor
                CPU1ByteRenderer.mDRMuxOutArrowColor = CPU1ByteRenderer.mDRMuxColor
            }
        case .ALU:
             CPU1ByteRenderer.aLULineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
             CPU1ByteRenderer.aLUOutArrowColor = emptyValue ? UIColor.CPUColors.noFillColor :  UIColor.CPUColors.aluColor
             CPU1ByteRenderer.ALUInstruction = emptyValue ? "" : aluInstructionMap[intValue!]!
             CPU1ByteRenderer.ALUInputText = value
             
             if CPU1ByteRenderer.cMuxText == "1"{
                CPU1ByteRenderer.cMuxColor = CPU1ByteRenderer.aLUOutArrowColor
                CPU1ByteRenderer.cBusColor =  CPU1ByteRenderer.cMuxColor
                if CPU1ByteRenderer.mdrMuxText == "1"{
                    CPU1ByteRenderer.mDRMuxColor = CPU1ByteRenderer.cBusColor
                    CPU1ByteRenderer.mDRMuxOutArrowColor = CPU1ByteRenderer.mDRMuxColor
                }
            }
            
        case .CSMux:
            CPU1ByteRenderer.cSMuxLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.csMuxText = value
        
        case .SCk:
            CPU1ByteRenderer.sCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.sCkText = value == "1" ? "✓" : value
            
        case .CCk:
            CPU1ByteRenderer.cCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.cCkText = value == "1" ? "✓" : value
            
        case .VCk:
            CPU1ByteRenderer.vCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.vCkText = value == "1" ? "✓" : value
            
        case .AndZ:
            CPU1ByteRenderer.andZLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.andZText = value
            
        case .ZCk:
            CPU1ByteRenderer.zCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.zCkText = value == "1" ? "✓" : value
            
        case .NCk:
            CPU1ByteRenderer.nCkLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.nCkText = value == "1" ? "✓" : value
            
        case .MemWrite:
            if CPU1ByteRenderer.memRdText == ""{
                CPU1ByteRenderer.memWrLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
                CPU1ByteRenderer.memWrText = value
                
                CPU1ByteRenderer.addrBusColor = emptyValue ? UIColor.CPUColors.noFillColor : UIColor.CPUColors.addressBusColor
            }
            
        case .MemRead:
            if CPU1ByteRenderer.memWrText == "" {
                CPU1ByteRenderer.memReadLineColor = emptyValue ? UIColor.CPUColors.grayArrow : UIColor.CPUColors.blackArrow
                CPU1ByteRenderer.memRdText = value
                
                CPU1ByteRenderer.addrBusColor = emptyValue ? UIColor.CPUColors.noFillColor : UIColor.CPUColors.addressBusColor
                CPU1ByteRenderer.dataBusColor = emptyValue ? UIColor.CPUColors.noFillColor : UIColor.CPUColors.dataBusColor
                
            }
        //Registers
        case .Acc:
            if intValue != nil {
                CPU1ByteRenderer.accumulatorText = "0x" + String(format:"%04X", intValue!)
            }
            
        case .X:
            if intValue != nil {
                 CPU1ByteRenderer.indexRegisterText = "0x" + String(format:"%04X", intValue!)
            }
           
        case .SP:
            if intValue != nil {
                CPU1ByteRenderer.stackPointerText = "0x" + String(format:"%04X", intValue!)
            }
            
        case .PC:
            if intValue != nil {
                CPU1ByteRenderer.programCounterText = "0x" + String(format:"%04X", intValue!)
            }
            
        case .IR:
            if intValue != nil {
                CPU1ByteRenderer.instructionRegisterText = "0x" + String(format:"%06X", intValue!)
            }
            
        case .T1:
            if intValue != nil {
                CPU1ByteRenderer.t1Text = "0x" + String(format:"%02X", intValue!)
            }
            
        case .T2:
            if intValue != nil {
                CPU1ByteRenderer.t2Text = "0x" + String(format:"%04X", intValue!)
            }
            
        case .T3:
            if intValue != nil {
                CPU1ByteRenderer.t3Text = "0x" + String(format:"%04X", intValue!)
            }
            
        case .T4:
            if intValue != nil {
                CPU1ByteRenderer.t4Text = "0x" + String(format:"%04X", intValue!)
            }
            
        case .T5:
            if intValue != nil {
                CPU1ByteRenderer.t5Text = "0x" + String(format:"%04X", intValue!)
            }
            
        case .T6:
            if intValue != nil {
                CPU1ByteRenderer.t6Text = "0x" + String(format:"%04X", intValue!)
            }
        //Bits
        case .N:
            CPU1ByteRenderer.nBit = value
        case .Z:
            CPU1ByteRenderer.zBit = value
        case .V:
            CPU1ByteRenderer.vBit = value
        case .S:
            CPU1ByteRenderer.sBit = value
        case .cBit:
            CPU1ByteRenderer.cBit = value
            
        default:
            break
        }
    }
    
    //Simulator
    var registerBank = [UInt8]()
    var memoryRegisters : [EMemoryRegisters: UInt8] = [:]
    var NZVCSbits : UInt8 = 0
    var hadDataError = false
    var errorMessage = ""
    var controlSignals : [CPUEMnemonic: Int] = [:]
    var LINE_DISABLED = -1
    var mainBusState : MainBusState = .None
    var isALUCacheValid = false
    var ALUHasOutputCache = false
    var ALUOutputCache : UInt8 = 0
    var ALUStatusBitCache : UInt8 = 0
    
    //TODO:
        ///Move enums ot enum page
        ///Move vars back up top
        ///Set NZVCSBits from unitPre
        ///Make Sure .rawValue is right for the enums
        ///SetMemWord
        ///MARCK
    
    func loadSimulator(codeList : [CPUCode], cycleCount : Int, memView: MemoryView){
        self.codeList = codeList
        self.cycleCount = cycleCount
        self.codeIndex = 0
        self.codeLine = 0
        self.memoryView = memView
        for code in codeList {
            if code is UnitPreCode{
                let unitPreCode = code as! UnitPreCode
                handleUnitPreCode(unitPreCode: unitPreCode)
            }
        }
    }
    
    func handleUnitPreCode(unitPreCode : UnitPreCode){
        for spec in unitPreCode.unitPreList{
            if spec is RegSpecification{
                let regSpec = spec as! RegSpecification
                let line = regSpec.regAddress == .A ? .Acc : regSpec.regAddress
                updateCPU(line: line, value: String(regSpec.regValue))
            }
            
            if spec is StatusBitSpecification{
                let statSpec = spec as! StatusBitSpecification
                let line = statSpec.nzvcsAddress == .C ? .cBit : statSpec.nzvcsAddress
                updateCPU(line: line, value: statSpec.nzvcsValue == true ? "1" : "0")
            }
            
            if spec is MemSpecification{
                let memSpec = spec as! MemSpecification
                var bytesLeft = memSpec.numBytes - 1
                for bytes in 0..<memSpec.numBytes {
                    let value = ((memSpec.memValue >> (bytesLeft*8)) & 0xFF)
                    machine.mem[memSpec.memAddress + bytes] = value
                    bytesLeft -= 1
                }
                memoryView.update()
            }
        }
    }
    
    func getMicroLine()-> MicroCode {
        // TODO: account for error when given input where codeList is NIL
        //find microCode Line
        for i in codeIndex..<codeList.count{
            if codeList[i].isMicrocode(){
                codeIndex = i
                break
            }
            codeLine = codeLine + 1
            
        }
         let microCodeLine = codeList[codeIndex] as! MicroCode
        
        return microCodeLine
    }
    
    func singleStep() -> Int{
        let microCodeLine = getMicroLine()
        controlSignals = microCodeLine.mnemonicMap
        
        handleMainBusState()
        
        //check for errors
        if hadDataError{
            return -1
        }
        
        //set up variables
        var aluInstr = controlSignals[.ALU]
        var a : UInt8 = 0
        var b : UInt8 = 0
        var c : UInt8 = 0
        var alu : UInt8 = 0
        var NZVC : UInt8 = 0
        var address : UInt16
        
        let hasA = valueOnABus(result: &a)
        let hasB = valueOnBBus(result: &b)
        let hasC = valueOnCBus(result: &c)
        
        var statusBitError = false
        var hasALUOutput = calculateALUOutput(res: &alu, NZVC: &NZVC)
        
        //Handle write to memory
        if(mainBusState == .MemWriteReady) {
            var address : UInt16 = UInt16((memoryRegisters[.MEM_MARA]!<<8) + memoryRegisters[.MEM_MARB]!)
            address &= 0xFFFE //Memory access ignores lowest order bit
            //setMemoryWord(quint16: address, value: value)
            //memory->setMemoryWord(address, memoryRegisters[Enu::MEM_MDRE]*256 + memoryRegisters[Enu::MEM_MDRO]);
        }
        
        //MARCk
        if controlSignals[.MARCk] != 0 { /// CHECK THIS
            if controlSignals[.MARMux] == 0 {
                //If MARMux is 0, route MDRE, MDRO to MARA, MARB
//                onSetMemoryRegister(Enu::MEM_MARA, memoryRegisters[Enu::MEM_MDRE]);
//                onSetMemoryRegister(Enu::MEM_MARB, memoryRegisters[Enu::MEM_MDRO]);
            }
            else if controlSignals[.MARMux] == 1 && hasA && hasB {
                //If MARMux is 1, route A, B to MARA, MARB
//                onSetMemoryRegister(Enu::MEM_MARA, a);
//                onSetMemoryRegister(Enu::MEM_MARB,b );
            }
            else {  //Otherwise MARCk is high, but no data flows through MARMux
                hadDataError = true
                errorMessage = "MARMux has no output but MARCk"
                return -1
            }
        }

        

        //LoadCk
        if controlSignals[.LoadCk] != 0 {
            if controlSignals[.C] == LINE_DISABLED {
                hadDataError = true
                errorMessage = "No destination register specified for LoadCk."
            }
            else if !hasC {
                hadDataError = true
                errorMessage = "No value on C Bus to clock in."
            }
            else {
                //onSetRegisterByte(controlSignals[Enu::C], c)
            }
        }

        
        for mnemon in microCodeLine.mnemonicMap.keys{
            let value = microCodeLine.mnemonicMap[mnemon] == -1 ? "" : String(microCodeLine.mnemonicMap[mnemon]!)
            
            updateCPU(line: mnemon, value: value)
        }
        
        codeIndex = codeIndex + 1
        codeLine = codeLine + 1
        
        return codeLine
    }
    
    func simulate(codeList : [CPUCode], cycleCount : Int){
        for code in codeList{
            if code.isMicrocode() {
                let microCodeLine = code as! MicroCode
                for mnemon in microCodeLine.mnemonicMap.keys {
                    if microCodeLine.mnemonicMap[mnemon] != -1 {
                        let value = String(microCodeLine.mnemonicMap[mnemon]!)
                        updateCPU(line: mnemon, value: value)
                    }
                
                }
            }
        }
    }
    
    func setMemoryWord(quint16 address : UInt8, value : UInt16) {
        // DO THIS Talk TO Matt
    }
    
    func aluFnIsUnary() -> Bool {
        //The only alu functions that are unary are 0 & 10..15
        return controlSignals[.ALU]! == 0 || controlSignals[.ALU]! >= 10
    }
    
    func valueOnABus(result : inout UInt8) -> Bool {
        if controlSignals[.A] == LINE_DISABLED {
            return false
        }
        result = UInt8(controlSignals[.A]!)
        return true
    }
    
    func valueOnBBus(result : inout UInt8) -> Bool {
        if controlSignals[.B] == LINE_DISABLED {
            return false
        }
        result = UInt8(controlSignals[.B]!)
        return true
    }
    
    func valueOnCBus(result : inout UInt8) -> Bool {
        if controlSignals[.CMux] == 0 {
            //If CMux is 0, then the NZVC bits (minus S) are directly routed to result
            result = NZVCSbits & (~EMask.SMask.rawValue)
            return true
        }
        else if controlSignals[.CMux] == 1 {
            var temp : UInt8 = 0  //Discard NZVC bits for this calculation, they are unecessary for calculating C's output
            //Otherwise the value of C depends solely on the ALU
            return calculateALUOutput(res: &result, NZVC: &temp)
        }
        else {
            return false
        }
    }
    
    func getAMuxOutput(result : inout UInt8) -> Bool {
        if(controlSignals[.AMux] == 0) {
            // Look at MDR (Needs to be different for 2 Byte Bus)
            result = memoryRegisters[.MEM_MDR]!
            return true
        }
        else if controlSignals[.AMux] == 1  {
            return valueOnABus(result: &result);
        }
        else{
            return false
        }
    }
    
    func calculateCSMuxOutput(result : inout UInt8) -> Bool {
    //CSMux either outputs C when CS is 0
    if controlSignals[.CSMux] == 0 {
        result = NZVCSbits & EMask.CMask.rawValue
        return true
    }
   //Or outputs S when CS is 1
    else if controlSignals[.CSMux] == 1  {
        // CHECK MY CISM STUFF
        result = NZVCSbits & EMask.SMask.rawValue
    return true
    }
    else{
         //Otherwise it does not have valid output
        return false
        }
    }
    
    
    ///
    
    enum EMemoryRegisters {
        case MEM_MARA; case MEM_MARB; case MEM_MDR; case MEM_MDRO; case MEM_MDRE
    }
    
    ///
    func handleMainBusState(){
        var marChanged = false
        var a : UInt8 = 0
        var b : UInt8 = 0
        
        if controlSignals[.MARCk] != 0 && valueOnABus(result: &a) && valueOnBBus(result: &b) {
            marChanged = !(a == memoryRegisters[.MEM_MARA] && b == memoryRegisters[.MEM_MARB])
        }
        switch mainBusState {
        case .None:
            //One cannot change MAR contents and initiate a R/W on same cycle
            if !marChanged {
                if controlSignals[.MemRead] == 1{
                    mainBusState = .MemReadFirstWait
                }
                else if controlSignals[.MemWrite] == 1{
                    mainBusState = .MemWriteFirstWait
                }
            }
            
        case .MemReadFirstWait:
            if !marChanged && controlSignals[.MemRead] == 1{
                mainBusState = .MemReadSecondWait
            }
            else if marChanged && controlSignals[.MemRead] == 1{
                //Initiating a new read brings us back to first wait
                //LOL Do we need this??
            }
            else if controlSignals[.MemWrite] == 1{
                //Switch from read to write.
                mainBusState = .MemWriteFirstWait
            }
            else{
                //If neither are check, bus goes back to doing nothing
                mainBusState = .None;
            }
            
        case .MemReadSecondWait:
            if !marChanged && controlSignals[.MemRead] == 1 {
                mainBusState = .MemReadReady
            }
            else if marChanged && controlSignals[.MemRead] == 1 {
                mainBusState = .MemReadFirstWait
            }
            else if controlSignals[.MemWrite] == 1 {
                mainBusState = .MemWriteFirstWait
            }
            else{
                mainBusState = .None //If neither are check, bus goes back to doing nothing
            }
            
        case .MemReadReady:
            if controlSignals[.MemRead] == 1 {
                mainBusState = .MemReadFirstWait //Another MemRead will bring us back to first MemRead, regardless of it MarChanged
            }
            else if controlSignals[.MemWrite] == 1 {
                mainBusState = .MemWriteFirstWait
            }
            else {
                mainBusState = .None //If neither are check, bus goes back to doing nothing
            }
            
        case .MemWriteFirstWait:
            if !marChanged && controlSignals[.MemWrite] == 1 {
                mainBusState = .MemWriteSecondWait
            }
            else if marChanged && controlSignals[.MemWrite] == 1 {
                //Initiating a new write brings us back to first wait
                //LOL DO we need this one either???
            }
            else if controlSignals[.MemRead] == 1{
                //Switch from write to read.
                mainBusState = .MemReadFirstWait
            }
                
            else {
                mainBusState = .None //If neither are check, bus goes back to doing nothing
            }
            
        case .MemWriteSecondWait:
            if !marChanged && controlSignals[.MemWrite] == 1{
                mainBusState = .MemWriteReady
                
            }
            else if marChanged && controlSignals[.MemWrite] == 1 {
                mainBusState = .MemWriteFirstWait; //Initiating a new write brings us back to first wait
            }
            else if controlSignals[.MemRead] == 1 {
                mainBusState = .MemReadFirstWait //Switch from write to read.
            }
            else {
                mainBusState = .None //If neither are check, bus goes back to doing nothing
            }
            
        case .MemWriteReady:
            if controlSignals[.MemWrite] == 1 {
                mainBusState = .MemWriteFirstWait //Another MemWrite will reset the bus state back to first MemWrite
            }
            else if controlSignals[.MemRead] == 1{
                mainBusState = .MemReadFirstWait //Switch from write to read.
            }
            else {
                mainBusState = .None //If neither are check, bus goes back to doing nothing
            }
            
        }

    }
    
    func calculateALUOutput(res : inout UInt8, NZVC : inout UInt8) -> Bool {
        if isALUCacheValid {
            res = ALUOutputCache
            NZVC = ALUStatusBitCache
            return ALUHasOutputCache
        }
        //This function should not set any errors.
        //Errors will be handled by step(..)
        var a : UInt8 = 0
        var b : UInt8 = 0
        //bool carryIn = 0; ---- might have issues with this
        var carryIn : UInt8 = 0
        
        let hasA = getAMuxOutput(result: &a)
        let hasB = valueOnBBus(result: &b)
        var hasCIn = calculateCSMuxOutput(result: &carryIn)
        
        
        
        if(!((aluFnIsUnary() && hasA) || (hasA && hasB))) {
            //The ALU output calculation would not be meaningful given its current function and inputs
            isALUCacheValid = true
            ALUHasOutputCache = false
            return ALUHasOutputCache
        }
        //Unless otherwise noted, do not return true (sucessfully) early, or the calculation for the NZ bits will be skipped
        switch(controlSignals[.ALU]) {
        case 0: //A
            res = a
            
        case 1: //A plus B
            res = a + b
            NZVC |= EMask.CMask.rawValue * (UInt8(res<a||res<b ? 0 : 1)) //Carry out if result is unsigned less than a or b. ///Double check this
            //There is a signed overflow iff the high order bits of the input are the same,
            //and the inputs & output differs in sign.
            NZVC |= EMask.VMask.rawValue * ((~(a^b)&(a^res))>>7) //Dividing by 128 and >>7 are the same thing for unsigned integers
            
        case 2: //A plus ~B plus 1
            hasCIn = true
            carryIn = 1
            
        case 3: //A plus ~B plus Cin
            hasCIn = true
            carryIn = 1
            b = ~b
            
        case 4: //A plus B plus Cin
            hasCIn = true
            carryIn = 1
            if !hasCIn {
                return false
            }
            res = a + b + carryIn;
            NZVC |= EMask.CMask.rawValue * (UInt8(res<a||res<b ? 0 : 1)) //Carry out if result is unsigned less than a or b.
            //There is a signed overflow iff the high order bits of the input are the same,
            //and the inputs & output differs in sign.
            NZVC |= EMask.VMask.rawValue * ((~(a^b)&(a^res))>>7)
            
        case 5: //A*B
            res = a&b
            
        case 6: //~(A*B)
            res = ~(a&b)
            
        case 7: //A+B
            res = a|b
            
        case 8: //~(A+B)
            res = ~(a|b)
            
        case 9: //A xor B
            res = a^b
            
        case 10: //~A
            res = ~a
            
        case 11: //ASL A
            res = a<<1
            NZVC |= EMask.CMask.rawValue * ((a & 0x80) >> 7)
            NZVC |= EMask.VMask.rawValue * (((a<<1)^a)>>7) //Signed overflow if a<hi> doesn't match a<hi-1>
            break;
        case 12: //ROL A
            if !hasCIn {
                return false
            }
            res = (a<<1) | carryIn
            NZVC |= EMask.CMask.rawValue * ((a & 0x80) >> 7)
            NZVC |= EMask.VMask.rawValue * (((a<<1)^a)>>7) //Signed overflow if a<hi> doesn't match a<hi-1>
            
        case 13: //ASR A
            hasCIn = true
            carryIn = a&128 //RORA and ASRA only differ by how the carryIn is calculated
            
        case 14: //ROR a
            hasCIn = true
            carryIn = a&128
            
            if !hasCIn {
                return false
            }
            res = (a>>1) | (carryIn<<7) //No need to worry about sign extension on shift with unsigned a
            NZVC |= EMask.CMask.rawValue * (a&1)
            
        case 15: //Move A to NZVC
            res = 0
            NZVC |= EMask.NMask.rawValue&a
            NZVC |= EMask.ZMask.rawValue&a
            NZVC |= EMask.VMask.rawValue&a
            NZVC |= EMask.CMask.rawValue&a
            return true //Must return early to avoid NZ calculation
        default:
            //If the default has been hit, then an invalid function was selected
            return false
        }
        //Get boolean value for N, then shift to correct place
        NZVC |= (res > 127) ? EMask.NMask.rawValue : 0
        //Get boolean value for Z, then shift to correct place
        NZVC |= (res == 0) ? EMask.ZMask.rawValue : 0
        ALUOutputCache = res
        ALUStatusBitCache = NZVC
        isALUCacheValid = true
        ALUHasOutputCache = true
        return ALUHasOutputCache
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func singleStep(errorMessage: inout String) -> Bool {
        
        
        
        
        return false
//        // Clear modified bytes for simulation view:
//        Sim::modifiedBytes.clear();
//        
//        // Update Bus State
//        // FSM that sets Sim::mainBusState to Enu::BusState - 5 possible states
//        updateMainBusState();
//        
//        // Status bit calculations
//        int aluFn = cpuPaneItems->ALULineEdit->text().toInt();
//        int carry;
//        int overflow;
//        quint8 result, a, b;
//        
//        QString errtemp;
//        Sim::getALUOut(result, a, b, carry, overflow, errtemp, cpuPaneItems); // ignore boolean returned - error would have been handled earlier
//        
//        if (Sim::mainBusState == Enu::MemReadReady) {
//            // we are performing a 2nd consecutive MemRead
//            // do nothing - the memread is performed in the getMDRMuxOut fn
//        }
//        else if (Sim::mainBusState == Enu::MemWriteReady) {
//            // we are performing a 2nd consecutive MemWrite
//            int address = Sim::MARA * 256 + Sim::MARB;
//            Sim::writeByte(address, Sim::MDR);
//            emit writeByte(address);
//        }
//        
//        // MARCk
//        if (cpuPaneItems->MARCk->isChecked()) {
//            quint8 a, b;
//            if (Sim::getABusOut(a, errorString, cpuPaneItems) && Sim::getBBusOut(b, errorString, cpuPaneItems)) {
//                setRegister(Enu::MARA, a);
//                setRegister(Enu::MARB, b);
//            }
//            else {
//                // error: MARCk is checked but we have incorrect input
//                return false;
//            }
//        }
//        
//        // LoadCk
//        if (cpuPaneItems->loadCk->isChecked()) {
//            int cDest = cpuPaneItems->cLineEdit->text().toInt();
//            quint8 out;
//            if (cpuPaneItems->cLineEdit->text() == "") {
//                errorString.append("No destination register specified for LoadCk.");
//                return false;
//            }
//            if (Sim::getCMuxOut(out, errorString, cpuPaneItems)) {
//                setRegisterByte(cDest, out);
//            }
//            else {
//                return false;
//            }
//        }
//        
//        // MDRCk
//        if (cpuPaneItems->MDRCk->isChecked()) {
//            quint8 out = 0;
//            if (Sim::getMDRMuxOut(out, errorString, cpuPaneItems)) {
//                setRegister(Enu::MDR, out);
//                int address = Sim::MARA * 256 + Sim::MARB;
//                emit readByte(address);
//            }
//            else {
//                return false;
//            }
//        }
//        
//        if (aluFn == 15) {
//            if (cpuPaneItems->NCkCheckBox->isChecked()) { // NCk
//                setStatusBit(Enu::N, Enu::NMask & a);
//            }
//            if (cpuPaneItems->ZCkCheckBox->isChecked()) { // ZCk
//                setStatusBit(Enu::Z, Enu::ZMask & a);
//            }
//            if (cpuPaneItems->VCkCheckBox->isChecked()) { // VCk
//                setStatusBit(Enu::V, Enu::VMask & a);
//            }
//            if (cpuPaneItems->CCkCheckBox->isChecked()) { // CCk
//                setStatusBit(Enu::C, Enu::CMask & a);
//            }
//        }
//        else {
//            // NCk
//            if (cpuPaneItems->NCkCheckBox->isChecked()) {
//                setStatusBit(Enu::N, result > 127);
//            }
//            
//            // ZCk
//            if (cpuPaneItems->ZCkCheckBox->isChecked()) {
//                if (cpuPaneItems->AndZTristateLabel->text() == ""){
//                    errorString.append("ZCk without AndZ.");
//                    return false;
//                }
//                if (cpuPaneItems->AndZTristateLabel->text() == "0") { // zOut from ALU goes straight through
//                    setStatusBit(Enu::Z, result == 0);
//                }
//                else if (cpuPaneItems->AndZTristateLabel->text() == "1") { // zOut && zCurr
//                    setStatusBit(Enu::Z, result == 0 && Sim::zBit);
//                }
//            }
//            
//            // VCk
//            if (cpuPaneItems->VCkCheckBox->isChecked()) {
//                setStatusBit(Enu::V, overflow & 0x1);
//            }
//            
//            // CCk
//            if (cpuPaneItems->CCkCheckBox->isChecked()) {
//                setStatusBit(Enu::C, carry & 0x1);
//            }
//            
//            // SCk
//            if (cpuPaneItems->SCkCheckBox->isChecked()) {
//                setStatusBit(Enu::S, carry & 0x1);
//            }
//        }
//        
//        return true;
//    }
//}
    }
}
