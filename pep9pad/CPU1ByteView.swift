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
                let value = memSpec.memValue
//                for bytes in 0..<memSpec.numBytes{
//                    let valForByte = 0 ^ value
//                }
                memoryView.update()
            }
        }
    }
    
    func singleStep() -> Int{
        //find microCode Line
        for i in codeIndex..<codeList.count{
            if codeList[i].isMicrocode(){
                codeIndex = i
                break
            }
                codeLine = codeLine + 1
            
        }
        
        let microCodeLine = codeList[codeIndex] as! MicroCode
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
