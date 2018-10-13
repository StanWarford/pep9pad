//
//  CPU1ByteView.swift
//  pep9pad
//
//  Created by Stan Warford on 2/20/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

@IBDesignable
class CPU1ByteView: CPUView {
    
    var thisRect: CGRect!
    
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
        switch (line){
        case .A:
            CPU1ByteRenderer.aLineColor = UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.aBusColor = UIColor.CPUColors.aBusColor
            CPU1ByteRenderer.aText = value
        case .B:
            CPU1ByteRenderer.bLineColor = UIColor.CPUColors.blackArrow
            CPU1ByteRenderer.bBusColor = UIColor.CPUColors.bBusColor
            CPU1ByteRenderer.bText = value
        default:
            break
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
