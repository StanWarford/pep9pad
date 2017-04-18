//
//  Pep9ProcessorController
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class Pep9ProcessorController: UIViewController {

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
    
    /// Pulls data from the registers in `machine`, decodes that data with 
    /// `maps`, and inserts that data into the approprate `UITextField`.
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
        spDec.text = "\(machine.stackPointer)"
        
        pcHex.text = "0x\(machine.programCounter.toHex4())"
        pcDec.text = "\(machine.programCounter)"
        
        instrSpecBin.text = machine.instructionSpecifier.toBin8()
        instrSpecMnemon.text = " " + maps.enumToMnemonMap[maps.decodeMnemonic[machine.instructionSpecifier]]! + maps.commaSpaceStringForAddrMode(addressMode: addrMode)
        
        if maps.decodeAddrMode[machine.instructionSpecifier] == .None {
            oprndSpecDec.text = ""
            oprndSpecHex.text = ""
            oprndDec.text = ""
            oprndHex.text = ""
        } else {
            oprndSpecHex.text = "0x\(machine.operandSpecifier.toHex4())"
            oprndSpecDec.text = "\(machine.toSignedDecimal(machine.operandSpecifier))"
            oprndHex.text = "0x\(machine.operand.toHex4())"
            oprndDec.text = "\(machine.toSignedDecimal(machine.operand))"
        }
    }


    func clearCpu() {
        
        nBit.text = ""
        zBit.text = ""
        vBit.text = ""
        cBit.text = ""
        
        accHex.text = ""
        accDec.text = ""
        
        xHex.text = ""
        xDec.text = ""
        
        spHex.text = ""
        spDec.text = ""
        
        pcHex.text = ""
        pcDec.text = ""
        
        instrSpecBin.text = ""
        instrSpecMnemon.text = ""
        
        oprndSpecHex.text = ""
        oprndSpecDec.text = ""
        oprndHex.text = ""
        oprndDec.text = ""
        
        machine.nBit = false
        machine.zBit = false
        machine.vBit = false
        machine.cBit = false
        
        machine.accumulator = 0
        machine.indexRegister = 0
        machine.stackPointer = 0
        machine.programCounter = 0


    }
}
