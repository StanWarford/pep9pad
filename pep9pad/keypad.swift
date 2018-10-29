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
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
       // https://digitalsynopsis.com/design/beautiful-color-gradients-backgrounds/
            let gradientLayer = CAGradientLayer()
            
            gradientLayer.frame = self.bounds
        
            let blue = UIColor(red:0.63, green:0.77, blue:0.99, alpha:1.0).cgColor
            let lightBlue = UIColor(red:0.76, green:0.91, blue:0.98, alpha:1.0).cgColor
            gradientLayer.colors = [blue,lightBlue]
        
        
        
            self.layer.insertSublayer(gradientLayer, at: 0)
    }
 
    
    @IBOutlet weak var mCodeLabel : UILabel!{
        didSet{
            mCodeLabel.text = ""
        }
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate.hideKeyboard()
        mCodeLabel.text = ""
    }
    @IBAction func backspacePressed(_ sender: Any) {
        delegate.backspacePressed(label: mCodeLabel)
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        let value = sender.titleLabel?.text
        if value == "Next" || value == "Prev"{
            
        }else{
            delegate.keyPressed(value : value!, label: mCodeLabel)
        }
    }
}
