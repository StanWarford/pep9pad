//
//  StackCell.swift
//  pep9pad
//
//  Created by Josh Haug on 8/12/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

/// This StackCell is actually used for Globals and Heap cells.
class StackCell: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var fmt: ESymbolFormat!
    var addr: Int!
    
    var initialized: Bool = false
    
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func updateValue() {
        var oldVal = valueLabel.text
        
        switch (fmt!) {
        case .F_1C:
            valueLabel.text = "\(machine.mem[addr].toASCII())"
        case .F_1D:
            valueLabel.text = "\(machine.mem[addr])"
        case .F_2D:
            valueLabel.text = "\(machine.toSignedDecimal(machine.mem[addr]*256+machine.mem[addr+1]))"
        case .F_1H:
            valueLabel.text = machine.mem[addr].toHex2()
        case .F_2H:
            valueLabel.text = (machine.mem[addr]*256 + machine.mem[addr+1]).toHex4()
        case .F_NONE:
            print("ERROR in updateValue")
            valueLabel.text = "err"
            break
        }
        
        if valueLabel.text == "" {
            valueLabel.text = "none"
        }
        
        // stop here if this is the cell's creation
        if !initialized {
            initialized = true
            return
        }
        
        //let c = appSettings.getColorFor(.text)
        let c = UIColor.black
        self.valueLabel.textColor = c
        self.addressLabel.textColor = c
        self.nameLabel.textColor = c
        self.valueLabel.layer.borderColor = c.cgColor
        
        
        // if the value is changing, make the cell red
        if oldVal != valueLabel.text {
            self.valueLabel.backgroundColor = .red
        } else {
            self.valueLabel.backgroundColor = .clear
        }
    }
    
    
}
