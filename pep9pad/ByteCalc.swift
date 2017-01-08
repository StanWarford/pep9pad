//
//  ByteCalc.swift
//  pep9pad
//
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class ByteCalc: NSObject, UITextFieldDelegate {
    
    
    
    // MARK: - Properties 
    
    var decimalField: UITextField! {
        didSet {
            decimalField.delegate = self
            decimalField.tag = 0
            decimalField.addConstraintLabel(text: "decimal")
        }
    }
    
    var hexField: UITextField! {
        didSet {
            hexField.delegate = self
            hexField.tag = 1
            hexField.addConstraintLabel(text: "hex")
        }
    }
    
    var binaryField: UITextField! {
        didSet {
            binaryField.delegate = self
            binaryField.tag = 2
            binaryField.addConstraintLabel(text: "binary")
        }
    }

    var asciiField: UITextField! {
        didSet {
            asciiField.delegate = self
            asciiField.tag = 3
            asciiField.addConstraintLabel(text: "ascii")
        }
    }

    var opcodeField: UITextField! {
        didSet {
            opcodeField.delegate = self
            opcodeField.tag = 4
            opcodeField.addConstraintLabel(text: "assembly")
        }
    }
    
    
    // for assistance with tags...
    
    let dec = 0
    let hex = 1
    let bin = 2
    let ascii = 3
    let opcode = 4

    
    
    
    func convertFrom(_ textField: UITextField) {
        // Note: by conditionally unwrapping into a UInt8 we ensure that the value is between 0 and 255.
        
        switch textField.tag {
        case dec:
            if let d = UInt8(textField.text!) {
                hexField.text = d.toHex2()
                binaryField.text = d.toBin8()
                asciiField.text = d.toASCII()
                // TODO: opcode
            }
            
        case hex:
            if let d = UInt8(textField.text!, radix: 16) {
                decimalField.text = String(d)
                binaryField.text = d.toBin8()
                asciiField.text = d.toASCII()
                // TODO: opcode
            }
            
        case bin:
            if let d = UInt8(textField.text!, radix: 2) {
                decimalField.text = String(d)
                hexField.text = d.toHex2()
                asciiField.text = d.toASCII()
                // TODO: opcode
            }
            
        default:
            break
        }
    }
    
    
    // MARK: - Fulfilling Obligations as UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // editing opcodeField is not allowed
        return textField != opcodeField
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Change the characters manually, do the necessary conversions, and then return false.
        // Ideally we'd do conversions in `textField(:didChangeCharactersIn:)` but that doesn't exist.
        // So I'll mimics that behavior instead.
        
        textField.curs
        
        // Rather than convert `range` from an `NSRange` to a `Range<String.Index>`, just make the text an NSString.
        var text = textField.text! as NSString
        textField.text = text.replacingCharacters(in: range, with: string)
        convertFrom(textField)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        switch textField.tag {
//        case dec:
//            // must be between 0 and 255
//            
//        }
        
        print(textField.text)
    }
    
    
}
