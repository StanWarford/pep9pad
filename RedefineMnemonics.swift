//
//  RedefineMnemonics.swift
//  pep9pad
//
//  Created by paul haefele on 3/23/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class RedefineMnemonics: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var unaryTextField1: UITextField! {
        didSet {
            unaryTextField1.delegate = self
            unaryTextField1.tag = 0
            unaryTextField1.addLabel(text: "0010 0110")
        }
    }
    
    var unaryTextField2: UITextField! {
        didSet {
            unaryTextField2.delegate = self
            unaryTextField2.tag = 1
            unaryTextField2.addLabel(text: "0010 0111")
        }
    }
    
    var nonUnaryTextField1: UITextField! {
        didSet {
            nonUnaryTextField1.delegate = self
            nonUnaryTextField1.tag = 2
            nonUnaryTextField1.addLabel(text: "00101")
        }
    }
    
    var nonUnaryTextField2: UITextField! {
        didSet {
            nonUnaryTextField2.delegate = self
            nonUnaryTextField2.tag = 3
            nonUnaryTextField2.addLabel(text: "00110")
        }
    }
    
    var nonUnaryTextField3: UITextField! {
        didSet {
            nonUnaryTextField3.delegate = self
            nonUnaryTextField3.tag = 4
            nonUnaryTextField3.addLabel(text: "00111")
        }
    }
    
    var nonUnaryTextField4: UITextField! {
        didSet {
            nonUnaryTextField4.delegate = self
            nonUnaryTextField4.tag = 5
            nonUnaryTextField4.addLabel(text: "01000")
        }
    }
    
    var nonUnaryTextField5: UITextField! {
        didSet {
            nonUnaryTextField5.delegate = self
            nonUnaryTextField5.tag = 6
            nonUnaryTextField5.addLabel(text: "01001")
        }
    }
    
    // for assistance with tags...
    
    let unary1 = 0
    let unary2 = 1
    let nonunary1 = 2
    let nonunary2 = 3
    let nonunary3 = 4
    let nonunary4 = 5
    let nonunary5 = 6
    
    
    
    
    
    
    
    
    // MARK: - Methods -
    func makeAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Redefine Mnemonics", message: nil, preferredStyle: .alert)
        
        alertController.addTextField() { unaryTextField1 in
            self.unaryTextField1 = unaryTextField1
        }
        
        alertController.addTextField() { unaryTextField2 in
            self.unaryTextField2 = unaryTextField2
        }
        
        alertController.addTextField() { nonUnaryTextField1 in
            self.nonUnaryTextField1 = nonUnaryTextField1
        }
        
        alertController.addTextField() { nonUnaryTextField2 in
            self.nonUnaryTextField2 = nonUnaryTextField2
        }
        
        alertController.addTextField() { nonUnaryTextField3 in
            self.nonUnaryTextField3 = nonUnaryTextField3
        }
        
        alertController.addTextField() { nonUnaryTextField4 in
            self.nonUnaryTextField4 = nonUnaryTextField4
        }
        
        alertController.addTextField() { nonUnaryTextField5 in
            self.nonUnaryTextField5 = nonUnaryTextField5
        }
        
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        
        return alertController
        
    }
    
    
    
    func convertAndPopulate(from textField: UITextField, textToConvert: String) {
        // Note: by conditionally unwrapping into a UInt8 we ensure that the value is between 0 and 255.
        
        if textToConvert.isEmpty {
            //clearAnyErrors()
            unaryTextField1.text = ""
            unaryTextField2.text = ""
            nonUnaryTextField1.text = ""
            nonUnaryTextField2.text = ""
            nonUnaryTextField3.text = ""
            nonUnaryTextField4.text = ""
            nonUnaryTextField5.text = ""
            return
        }
        
        
        switch textField.tag {
        case unary1:
           // TODO
            break
        case unary2:
            // TODO
            break
            
        case nonunary1:
            // TODO
            break
            
        case nonunary2:
            // TODO
            break
            
        case nonunary3:
            // TODO
            break
        case nonunary4:
            // TODO
            break
        case nonunary5:
            // TODO
            break
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
    
    
//    func errorInConverting(_ textField: UITextField, _ type: ConversionError) {
//        
//        let errorMessage = type.rawValue
//        errorToClear = textField.tag
//        let errorColor = appSettings.getColorFor(.errorText)
//        
//        switch textField.tag {
//        case unary1: unaryTextField1.addLabel(text: "Unary 1 - \(errorMessage)", color: errorColor)
//        case unary2: unaryTextField2.addLabel(text: "Unary 2 - \(errorMessage)", color: errorColor)
//        case nonunary1: nonUnaryTextField1.addLabel(text: "NonUnary 1 - \(errorMessage)", color: errorColor)
//        case nonunary2: nonUnaryTextField2.addLabel(text: "NonUnary 2 - \(errorMessage)", color: errorColor)
//        case nonunary3: nonUnaryTextField3.addLabel(text: "NonUnary 3 - \(errorMessage)", color: errorColor)
//        case nonunary4: nonUnaryTextField4.addLabel(text: "NonUnary 4 - \(errorMessage)", color: errorColor)
//        case nonunary5: nonUnaryTextField5.addLabel(text: "NonUnary 5 - \(errorMessage)", color: errorColor)
//        default: break
//            // user can't edit assemblyField, so won't get an error
//        }
//    }
//    
//    
//    func clearAnyErrors() {
//        if errorToClear == nil {
//            return
//        }
//        
//        switch errorToClear {
//        case dec: decimalField.addLabel(text: "Decimal")
//        case bin: binaryField.addLabel(text: "Binary")
//        case hex: hexField.addLabel(text: "Hex (0x)")
//        case ascii: asciiField.addLabel(text: "Ascii")
//        default: break
//        }
//        
//        errorToClear = nil
//    }
    
    
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
        convertAndPopulate(from: textField, textToConvert: newText)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    
}
