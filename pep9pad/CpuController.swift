//
//  CpuController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

// I know that 'CPUController' would be the correct capitalization but I think 'CpuController' is more readable. 

class CpuController: UIViewController {

    // MARK: - Interface Builder
    
    @IBOutlet weak var nBit: UITextField!
    @IBOutlet weak var zBit: UITextField!
    @IBOutlet weak var vBit: UITextField!
    @IBOutlet weak var cBit: UITextField!
    
    @IBOutlet weak var accHex: UITextField!
    @IBOutlet weak var accDec: UITextField!
    
    @IBOutlet weak var xHex: UITextField!
    @IBOutlet weak var xDec: UITextField!
    
    @IBOutlet weak var spHex: UITextField!
    @IBOutlet weak var spDec: UITextField!
    
    @IBOutlet weak var pcHex: UITextField!
    @IBOutlet weak var pcDec: UITextField!
    
    @IBOutlet weak var instrSpecBin: UITextField!
    @IBOutlet weak var instrSpecMnemon: UITextField!
    
    @IBOutlet weak var oprndSpecHex: UITextField!
    @IBOutlet weak var oprndSpecDec: UITextField!
    
    @IBOutlet weak var oprndHex: UITextField!
    @IBOutlet weak var oprndDec: UITextField!
    
//    @IBOutlet weak var traceTrapsSwitch: UISwitch!
//    
//    @IBOutlet weak var stepBtn: UIButton! {
//        didSet {
//            // On launch, step btn is disabled
//            self.stepBtn.enabled = false
//        }
//    }
//    @IBOutlet weak var resumeBtn: UIButton! {
//        didSet {
//            // On launch, resume btn is disabled
//            self.resumeBtn.enabled = false
//        }
//    }
    
    
    
    
    
    // MARK: - Methods
    
    func update() {
        let addrMode = maps.decodeAddrMode[machine.instructionSpecifier]
        
        nBit.text = machine.nBit.toIntString()
        zBit.text = machine.zBit.toIntString()
        vBit.text = machine.vBit.toIntString()
        cBit.text = machine.cBit.toIntString()

        accHex.text = "0x\(machine.accumulator.toHex4())"
        accDec.text = "\(machine.toSignedDecimal(machine.accumulator))"
        
        xHex.text = "0x\(machine.indexRegister.toHex4())"
        xDec.text = "\(machine.toSignedDecimal(machine.indexRegister))"
        
        spHex.text = "0x\(machine.stackPointer.toHex4())"
        spDec.text = "\(machine.toSignedDecimal(machine.stackPointer))"
        
        pcHex.text = "0x\(machine.programCounter.toHex4())"
        pcDec.text = "\(machine.toSignedDecimal(machine.programCounter))"
        
        instrSpecBin.text = machine.instructionSpecifier.toBin8()
        //instrSpecMnemon.text = " " + maps.enumToMnemonMap[maps.decodeMnemonic[machine.instructionSpecifier]]+
    }

//
//        ui->accHexLabel->setText(QString("0x") + QString("%1").arg(Sim::accumulator, 4, 16, QLatin1Char('0')).toUpper());
//        ui->accDecLabel->setText(QString("%1").arg(Sim::toSignedDecimal(Sim::accumulator)));
//        
//        ui->xHexLabel->setText(QString("0x") + QString("%1").arg(Sim::indexRegister, 4, 16, QLatin1Char('0')).toUpper());
//        ui->xDecLabel->setText(QString("%1").arg(Sim::toSignedDecimal(Sim::indexRegister)));
//        
//        ui->spHexLabel->setText(QString("0x") + QString("%1").arg(Sim::stackPointer, 4, 16, QLatin1Char('0')).toUpper());
//        ui->spDecLabel->setText(QString("%1").arg(Sim::stackPointer));
//        
//        ui->pcHexLabel->setText(QString("0x") + QString("%1").arg(Sim::programCounter, 4, 16, QLatin1Char('0')).toUpper());
//        ui->pcDecLabel->setText(QString("%1").arg(Sim::programCounter));
//        
//        ui->instrSpecBinLabel->setText(QString("%1").arg(Sim::instructionSpecifier, 8, 2, QLatin1Char('0')).toUpper());
//        ui->instrSpecMnemonLabel->setText(" " + Pep::enumToMnemonMap.value(Pep::decodeMnemonic[Sim::instructionSpecifier])
//        + Pep::addrModeToCommaSpace(addrMode));
//        
//        if (Pep::decodeAddrMode.value(Sim::instructionSpecifier) == Enu::NONE) {
//            ui->oprndSpecHexLabel->setText("");
//            ui->oprndSpecDecLabel->setText("");
//            ui->oprndHexLabel->setText("");
//            ui->oprndDecLabel->setText("");
//        }
//        else {
//            ui->oprndSpecHexLabel->setText(QString("0x") + QString("%1").arg(Sim::operandSpecifier, 4, 16, QLatin1Char('0')).toUpper());
//            ui->oprndSpecDecLabel->setText(QString("%1").arg(Sim::toSignedDecimal(Sim::operandSpecifier)));
//            ui->oprndHexLabel->setText(QString("0x") + QString("%1").arg(Sim::operand, Sim::operandDisplayFieldWidth, 16, QLatin1Char('0')).toUpper());
//            ui->oprndDecLabel->setText(QString("%1").arg(Sim::toSignedDecimal(Sim::operand)));
//        }
//    }

}
