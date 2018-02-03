//
//  RedefineMnemonics.swift
//  pep9pad
//
//  Created by paul haefele on 3/23/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class NonunaryMnemonics: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var unaryTextField1: UITextField! {
        didSet {
            unaryTextField1.delegate = self
            unaryTextField1.tag = 1
            unaryTextField1.addLabel(text: "0010 0110")
            unaryTextField1.text = "NOP0"
        }
    }
    
    var unaryTextField2: UITextField! {
        didSet {
            unaryTextField2.delegate = self
            unaryTextField2.tag = 2
            unaryTextField2.addLabel(text: "0010 0111")
            unaryTextField2.text = "NOP1"

        }
    }
    

    var alertView: UIView!
    
    // MARK: - Methods -
    func makeAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Redefine Unary Mnemonics", message: nil, preferredStyle: .alert)
   
        
        alertController.addTextField() { unaryTextField1 in
            self.unaryTextField1 = unaryTextField1
        }
        
        alertController.addTextField() { unaryTextField2 in
            self.unaryTextField2 = unaryTextField2
        }

        
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: nil)) // change mnemon stuff goes here
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Default", style: .default, handler: { (action) in
            // won't set textfields as this action dismisses the controller
            maps.restoreDefaultUnaryMnemonics()
        }))  // default stuff here

        return alertController
        
    }
    
    
    
    // MARK: - Fulfilling Obligations as UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // editing assemblyField is not allowed
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Change the characters manually, do the necessary conversions, and then return false.
        // Ideally we'd do conversions in `textField(:didChangeCharactersIn:)` but that doesn't exist.
        // So I'll mimic that behavior instead.
        
        // Rather than convert `range` from an `NSRange` to a `Range<String.Index>`, just make the text an NSString.
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as String
        // limit to length of 8 chars
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    
}
