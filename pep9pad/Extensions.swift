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
    
    func toBool() -> Bool {
        return self == 1 ? true : false
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
    // A convenience function for input fields.
    func addLabel(text: String, color: UIColor = .black) {
        let aLabel = UILabel()
        aLabel.text = text
        aLabel.font = UIFont(name: "Helvetica-Light", size: 14.0)
        aLabel.textColor = color
        aLabel.sizeToFit()
        self.leftView = aLabel
        self.leftViewMode = UITextFieldViewMode.always
        self.textAlignment = .right
    }
    
    func getCursorPosition(from: UITextPosition) -> Int? {
        if let selectedRange = self.selectedTextRange {
            return self.offset(from: from, to: selectedRange.start)
        }
        return nil
    }

}



extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
    
    func fullRange() -> NSRange {
        return NSMakeRange(0, self.characters.count)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    mutating func remove(_ from: Int, _ to: Int) {
        let startIdx = self.index(self.startIndex, offsetBy: from)
        let endIdx = self.index(startIdx, offsetBy: to)
        self.removeSubrange(startIdx..<endIdx)
    }
    
    func hasHexPrefix() -> Bool {
        return self.hasPrefix("0x") || self.hasPrefix("0X")
    }
}


extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
    
    func isDigit() -> Bool {
        return self == "0" || self == "1" || self == "2" || self == "3" || self == "4"
            || self == "5" || self == "6" || self == "7" || self == "8" || self == "9"
    }
}


extension NSRegularExpression {
    func appearsIn(_ str: String) -> Bool {
        return self.numberOfMatches(in: str, options: .reportCompletion, range: str.fullRange()) > 0
    }
    
    func matchesIn(_ str: String) -> [String] {
        let ns = str as NSString
        //return self.firstMatch(in: str, options: .reportCompletion, range: str.fullRange())?.components
        let results = matches(in: ns as String, range: NSRange(location: 0, length: ns.length))
        return results.map { ns.substring(with: $0.range)}
    }
}















