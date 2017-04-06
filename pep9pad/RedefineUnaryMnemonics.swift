//
//  RedefineMnemonics.swift
//  pep9pad
//
//  Created by paul haefele on 3/23/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class RedefineUnaryMnemonics: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties

    
    var unaryTextField1: UITextField! {
        didSet {
            unaryTextField1.delegate = self
            unaryTextField1.tag = 0
            unaryTextField1.addLabel(text: "0010 0110")
        }
    }
    
    var unaryLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
    
    var alertView: UIView! {
        didSet {
            unaryLabel.text = "WORKED FAM!"
            alertView.addSubview(unaryLabel)
        }
    }
 
    
    // for assistance with tags...
    
    let unary1 = 0
    
    // MARK: - Methods -
    func makeAlert() -> UIViewController {
        let viewController = UIViewController()
        let tableView = UITableViewCell()
        
        
        return viewController
        
    }
    
    
    
    func convertAndPopulate(from textField: UITextField, textToConvert: String) {
        // Note: by conditionally unwrapping into a UInt8 we ensure that the value is between 0 and 255.
        
        if textToConvert.isEmpty {
            //clearAnyErrors()
            unaryTextField1.text = ""
            return
        }
        
        
        switch textField.tag {
        case unary1:
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
