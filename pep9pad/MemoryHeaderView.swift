//
//  MemoryHeaderView.swift
//  pep9pad
//
//  Created by Sapharah Prescod on 3/20/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class MemoryHeaderView: UIView, UITextFieldDelegate {
    
    
   
    func initializeSubviews() {
        let view: UIView = Bundle.main.loadNibNamed("MemoryHeader", owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    
    var memoryView: MemoryView!
    
    @IBOutlet var searchField: UITextField! {
        didSet {
            self.searchField.delegate = self
        }
    }
    @IBOutlet var spBtn: UIButton!
    
    @IBOutlet var pcBtn: UIButton!
    
    @IBAction func spBtnPressed(_ sender: UIButton) {
        memoryView.scrollToByte(machine.stackPointer)
    }
   
    @IBAction func pcBtnPressed(_ sender: UIButton) {
        memoryView.scrollToByte(machine.programCounter)
        
        
    }
    

    // MARK: - Conformance to UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as String
        
        if let intVal = Int(newText, radix: 16) {
            if intVal > 65536 {
                memoryView.scrollToByte(65535)
            } else if intVal < 0 {
                memoryView.scrollToByte(0)
            } else {
                memoryView.scrollToByte(intVal)
            }
        }
        
        return true
    }
    
    
}
