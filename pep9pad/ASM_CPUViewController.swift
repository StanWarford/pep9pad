//
//  ASM_CPUViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/7/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_CPUViewController: UIViewController {

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
        let addrMode = Pep.decodeAddrMode[Sim.instructionSpecifier]
        
        nBit.text = Sim.nBit.toIntString()
        zBit.text = Sim.zBit.toIntString()
        vBit.text = Sim.vBit.toIntString()
        cBit.text = Sim.cBit.toIntString()

        accHex.text = "0x\(Sim.accumulator.toHex4())"
        accDec.text = "\(Sim.toSignedDecimal(Sim.accumulator))"
        
        xHex.text = "0x\(Sim.indexRegister.toHex4())"
        xDec.text = "\(Sim.toSignedDecimal(Sim.indexRegister))"
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
