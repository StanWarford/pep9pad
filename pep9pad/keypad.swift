//
//  keypad.swift
//  pep9pad
//
//  Created by David Nicholas on 10/28/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class keypad: UIView {
    
    var delegate : keypadDelegate!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func testButton(_ sender: UIButton) {
        let value = sender.titleLabel?.text
        if value == "Next" || value == "Prev"{
            
        }else{
            delegate.keyPressed(value : value!)
        }
    }
}
