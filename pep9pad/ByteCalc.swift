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
            decimalField.addLabel(text: "decimal")
        }
    }
    
    var hexField: UITextField! {
        didSet {
            hexField.delegate = self
            hexField.tag = 1
            hexField.addLabel(text: "hex")
        }
    }
    
    var binaryField: UITextField! {
        didSet {
            binaryField.delegate = self
            binaryField.tag = 2
            binaryField.addLabel(text: "binary")
        }
    }

    var asciiField: UITextField! {
        didSet {
            asciiField.delegate = self
            asciiField.tag = 3
            asciiField.addLabel(text: "ascii")
        }
    }

    var assemblyField: UITextField! {
        didSet {
            assemblyField.delegate = self
            assemblyField.tag = 4
            assemblyField.addLabel(text: "assembly")
        }
    }
    
    
    // for assistance with tags...
    
    let dec = 0
    let hex = 1
    let bin = 2
    let ascii = 3
    let assembly = 4
    
    
    func convertAndPopulate(_ textField: UITextField) {
        // Note: by conditionally unwrapping into a UInt8 we ensure that the value is between 0 and 255.
        
        switch textField.tag {
        case dec:
            if let d = UInt8(textField.text!) {
                clearAnyErrors()
                hexField.text = d.toHex2()
                binaryField.text = d.toBin8()
                asciiField.text = d.toASCII()
                // TODO: opcode
            } else if let _ = Int(textField.text!) {
                // can still be converted to an integer, but is out of bounds
                errorInConverting(textField, .outOfBounds)
            }
            
        case hex:
            if let d = UInt8(textField.text!, radix: 16) {
                clearAnyErrors()
                decimalField.text = String(d)
                binaryField.text = d.toBin8()
                asciiField.text = d.toASCII()
                // TODO: opcode
            }

        case bin:
            if let d = UInt8(textField.text!, radix: 2) {
                clearAnyErrors()
                decimalField.text = String(d)
                hexField.text = d.toHex2()
                asciiField.text = d.toASCII()
                // TODO: opcode
            } else if (textField.text?.characters.count)! > 8 {
                errorInConverting(textField, .outOfBounds)
            } else {
                errorInConverting(textField, .badInput)
            }

        case ascii:
            let firstChar = textField.text!.characters.first
            if let val = firstChar?.asciiValue {
                clearAnyErrors()
                let d = UInt8(val)
                decimalField.text = String(d)
                hexField.text = d.toHex2()
                binaryField.text = d.toBin8()
            }
            
        default:
            break
        }
    }
    
    var errorToClearIn: Int!
    
    enum ConversionError: String {
        case outOfBounds = "out of bounds"
        case badInput = "bad input"
        case other = "error"
    }
    
    func errorInConverting(_ textField: UITextField, _ type: ConversionError) {
        
        let errorMessage = type.rawValue
        
        errorToClearIn = textField.tag
        
        switch textField.tag {
        case dec: decimalField.addErrorLabel(text: "decimal - \(errorMessage)")
        case bin: binaryField.addErrorLabel(text: "binary - \(errorMessage)")
        case hex: hexField.addErrorLabel(text: "hex - \(errorMessage)")
        case ascii: asciiField.addErrorLabel(text: "ascii - \(errorMessage)")
        default: break
        // user can't edit assemblyField, so won't get an error
        }
    }
    
    
    func clearAnyErrors() {
        if errorToClearIn == nil {
            return
        }
        
        switch errorToClearIn {
        case dec: decimalField.addLabel(text: "decimal")
        case bin: binaryField.addLabel(text: "binary")
        case hex: hexField.addLabel(text: "hex")
        case ascii: asciiField.addLabel(text: "ascii")
        default: break
        }
        
        errorToClearIn = nil
    }
    
    
    // MARK: - Fulfilling Obligations as UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // editing assemblyField is not allowed
        return textField != assemblyField
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Change the characters manually, do the necessary conversions, and then return false.
        // Ideally we'd do conversions in `textField(:didChangeCharactersIn:)` but that doesn't exist.
        // So I'll mimic that behavior instead.
        
        let cursor = textField.selectedTextRange?.start
        
        // Rather than convert `range` from an `NSRange` to a `Range<String.Index>`, just make the text an NSString.
        var oldText = textField.text! as NSString
        var diff = range.length - string.characters.count
        textField.text = oldText.replacingCharacters(in: range, with: string)
        convertAndPopulate(textField)
        //textField.text = oldText as String
        // restore cursor position
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //print(textField.text)
    }
    
    
}
