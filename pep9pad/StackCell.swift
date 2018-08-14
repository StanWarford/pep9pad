//
//  StackCell.swift
//  pep9pad
//
//  Created by Josh Haug on 8/12/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

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
    
    @IBOutlet var value: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func updateValue() {
        var oldVal = value.text
        
        switch (fmt!) {
        case .F_1C:
            value.text = "\(machine.mem[addr].toASCII())"
        case .F_1D:
            value.text = "\(machine.mem[addr])"
        case .F_2D:
            value.text = "\(machine.toSignedDecimal(machine.mem[addr]*256+machine.mem[addr+1]))"
        case .F_1H:
            value.text = machine.mem[addr].toHex2()
        case .F_2H:
            value.text = (machine.mem[addr]*256 + machine.mem[addr+1]).toHex4()
        case .F_NONE:
            print("ERROR in updateValue")
            value.text = ""
            break
        }
        
        // if the value is changing, make the cell red
        if oldVal != value.text {
            //UIView.animate(withDuration: 0.3) {
            self.value.backgroundColor = .red
            //}
        } else {
            self.value.backgroundColor = .clear
        }
    }
    
    
}
