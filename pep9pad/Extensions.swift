//
//  Extensions.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

extension Bool {
    func toIntString() -> String {
        return self == true ? "1" : "0"
    }
    
    func toEnglish() -> String {
        return self == true ? "on" : "off"
    }
}

extension Int {
    func toHex4() -> String {
        return String(format:"%04X", self)
    }
    
    func toHex2() -> String {
        return String(format:"%02X", self)
    }
    
    func toBin8() -> String {
        var str = String(self, radix: 2)
        let len = str.characters.count
        if len > 8 {
            return "EEEEEEEE"
        }
        return String(repeating: "0", count: 8-str.characters.count) + str
    }
    
    func toASCII() -> String {
        return String(UnicodeScalar(self)!)
    }
}


extension UInt8 {
    func toHex4() -> String {
        return String(format:"%04X", self)
    }
    
    func toHex2() -> String {
        return String(format:"%02X", self)
    }

    
    func toBin8() -> String {
        var str = String(self, radix: 2)
        let len = str.characters.count
        if len > 8 {
            return "EEEEEEEE"
        }
        return String(repeating: "0", count: 8-str.characters.count) + str
    }
    
    func toASCII() -> String {
        return String(UnicodeScalar(self))
    }
}

extension UITextField {
    // A convenience function for the constraint input fields
    func addConstraintLabel(text: String) {
        let aLabel = UILabel()
        aLabel.text = text
        aLabel.font = UIFont(name: "Helvetica-Light", size: 14.0)
        aLabel.sizeToFit()
        self.leftView = aLabel
        self.leftViewMode = UITextFieldViewMode.always
        self.textAlignment = .right
    }
    
}
