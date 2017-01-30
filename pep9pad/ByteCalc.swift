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
            decimalField.addLabel(text: "Decimal")
        }
    }
    
    var hexField: UITextField! {
        didSet {
            hexField.delegate = self
            hexField.tag = 1
            hexField.addLabel(text: "Hex 0x")
        }
    }
    
    var binaryField: UITextField! {
        didSet {
            binaryField.delegate = self
            binaryField.tag = 2
            binaryField.addLabel(text: "Binary")
        }
    }

    var asciiField: UITextField! {
        didSet {
            asciiField.delegate = self
            asciiField.tag = 3
            asciiField.addLabel(text: "Ascii")
        }
    }

    var assemblyField: UITextField! {
        didSet {
            assemblyField.delegate = self
            assemblyField.tag = 4
            assemblyField.addLabel(text: "Instruction")
        }
    }
    
    
    // for assistance with tags...
    
    let dec = 0
    let hex = 1
    let bin = 2
    let ascii = 3
    let assembly = 4
    
    
    func convertAndPopulate(from textField: UITextField, textToConvert: String) {
        // Note: by conditionally unwrapping into a UInt8 we ensure that the value is between 0 and 255.
        
        if textToConvert.isEmpty {
            clearAnyErrors()
            decimalField.text = ""
            hexField.text = ""
            binaryField.text = ""
            asciiField.text = ""
            assemblyField.text = ""
            return
        }
        
        
        switch textField.tag {
        case dec:
            if let d = UInt8(textToConvert) {
                clearAnyErrors()
                hexField.text = d.toHex2()
                binaryField.text = d.toBin8()
                asciiField.text = d.toASCII()
                assemblyField.text = maps.getInstruction(Int(d))
            } else if let _ = Int(textToConvert) {
                // can still be converted to an integer, but is out of bounds
                errorInConverting(textField, .outOfBounds)
            } else {
                // bad input, probably
                errorInConverting(textField, .badInput)
                
            }
            
        case hex:
            if let d = UInt8(textToConvert, radix: 16) {
                clearAnyErrors()
                decimalField.text = String(d)
                binaryField.text = d.toBin8()
                asciiField.text = d.toASCII()
                assemblyField.text = maps.getInstruction(Int(d))
            } else {
                errorInConverting(textField, .badInput)
            }

        case bin:
            if let d = UInt8(textToConvert, radix: 2) {
                clearAnyErrors()
                decimalField.text = String(d)
                hexField.text = d.toHex2()
                asciiField.text = d.toASCII()
                assemblyField.text = maps.getInstruction(Int(d))
            } else if (textField.text?.characters.count)! > 8 {
                errorInConverting(textField, .outOfBounds)
            } else {
                errorInConverting(textField, .badInput)
            }

        case ascii:
            let firstChar = textToConvert.characters.first
            if let val = firstChar?.asciiValue {
                clearAnyErrors()
                let d = UInt8(val)
                decimalField.text = String(d)
                hexField.text = d.toHex2()
                binaryField.text = d.toBin8()
                assemblyField.text = maps.getInstruction(Int(d))
            } else {
                errorInConverting(textField, .badInput)
            }
            
        default:
            break
        }
    }
    
    var errorToClear: Int!
    
    enum ConversionError: String {
        case outOfBounds = "Out of Bounds"
        case badInput = "Bad Input"
        // case other = "error" // not needed
    }
    
    
    func errorInConverting(_ textField: UITextField, _ type: ConversionError) {
        
        let errorMessage = type.rawValue
        errorToClear = textField.tag
        let errorColor = appSettings.getColorFor(.errorText)
        
        switch textField.tag {
        case dec: decimalField.addLabel(text: "Decimal - \(errorMessage)", color: errorColor)
        case bin: binaryField.addLabel(text: "Binary - \(errorMessage)", color: errorColor)
        case hex: hexField.addLabel(text: "Hex - \(errorMessage) 0x", color: errorColor)
        case ascii: asciiField.addLabel(text: "Ascii - \(errorMessage)", color: errorColor)
        default: break
        // user can't edit assemblyField, so won't get an error
        }
    }
    
    
    func clearAnyErrors() {
        if errorToClear == nil {
            return
        }
        
        switch errorToClear {
        case dec: decimalField.addLabel(text: "Decimal")
        case bin: binaryField.addLabel(text: "Binary")
        case hex: hexField.addLabel(text: "Hex 0x")
        case ascii: asciiField.addLabel(text: "Ascii")
        default: break
        }
        
        errorToClear = nil
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
        
        // Rather than convert `range` from an `NSRange` to a `Range<String.Index>`, just make the text an NSString.
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as String
        convertAndPopulate(from: textField, textToConvert: newText)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    
}
