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

extension CGRect {
    func getCenter() -> CGPoint {
        return CGPoint(x: self.origin.x+0.5*self.width,
                       y: self.origin.y+0.5*self.height)
    }
}

extension Int {
    func toHex4() -> String {
        return String(format:"%04X", self)
    }
    
    func toHex2() -> String {
        return String(format:"%02X", self)
    }
    
    func toHex6() -> String {
        return String(format:"%06X", self)
    }
    
    func toBin8() -> String {
        let str = String(self, radix: 2)
        let len = str.count
        if len > 8 {
            return "EEEEEEEE"
        }
        return String(repeating: "0", count: 8-str.count) + str
    }
    
    func toASCII() -> String {
        return String(UnicodeScalar(self)!)
    }
    
    func toBool() -> Bool {
        return self != 0
    }
    
    func odd() -> Bool {
        return self % 2 != 0
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
        let str = String(self, radix: 2)
        let len = str.count
        if len > 8 {
            return "EEEEEEEE"
        }
        return String(repeating: "0", count: 8-str.count) + str
    }
    
    func toASCII() -> String {
        return String(UnicodeScalar(self))
    }
}

extension UInt16 {
    func toHex4() -> String {
        return String(format:"%04X", self)
    }
    func toBin8() -> String {
        let str = String(self, radix: 2)
        let len = str.count
        if len > 8 {
            return "EEEEEEEE"
        }
        return String(repeating: "0", count: 8-str.count) + str
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
        return NSMakeRange(0, self.count)
    }
    
    var length: Int {
        return self.count
    }
    
    mutating func remove(_ from: Int, _ to: Int) {
        let startIdx = self.index(self.startIndex, offsetBy: from)
        let endIdx = self.index(startIdx, offsetBy: to)
        self.removeSubrange(startIdx..<endIdx)
    }
    
    func hasHexPrefix() -> Bool {
        return self.hasPrefix("0x") || self.hasPrefix("0X")
    }
    
    func removeBackwards(untilFirstInstance  thing: String) -> String {
        var charArr = thing.characters
        let notFound = true
        var idx = charArr.count
        while notFound {
            charArr.removeLast()
            idx -= 1
        }
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    mutating func chop() {
        self.removeLast()
    }
    
//    func stringFormatter(str: String, fixLength: Int, spacer: String = " ", isNegative: Bool = true) -> String {
//        let paddedString = str.padding(toLength: fixLength, withPad: spacer, startingAt: 0)
//        return paddedString
//    }
    
    func padAfter(width: Int, spacer: String = " ", isNegative: Bool = true) -> String {
        let paddedString = self.padding(toLength: width, withPad: spacer, startingAt: 0)
        return paddedString
    }
    
    
    
    func startsWith(input: String) -> Bool {
        let length: Int = input.length
        if input == String(self.characters.prefix(length)) {
            return true
        }
        return false
    }
    
    func left(num: Int) -> String {
        return String(self.characters.prefix(num))
    }
    
    func stringToHex() -> String {
        return String(format: "%02X", self)
    }
    
    func toInt(value: Int) -> Int {
        if let d = Int(self, radix: value) {
            return Int(d)
        } else {
            return 0
        }
    }
    
    func hexToInt() -> Int {
        if let d = Int(self, radix: 16) {
            return Int(d)
        } else {
            return 0
        }
    }
}

extension Dictionary where Key:Any {
    func arrayOfKeys() -> [Any] {
        return Array(self.keys)
    }
    func arrayOfValues() -> [Any] {
        return Array(self.values)
    }
}


extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
    
    func isDigit() -> Bool {
        if let val = self.asciiValue {
            let numericAsciiRange: Range<UInt32> = 48..<58
            return numericAsciiRange.contains(val)
        }
        return false
    }
    
    func isLetter() -> Bool {
        if let val = self.asciiValue {
            let letterAsciiRangeUpper: Range<UInt32> = 65..<91
            let letterAsciiRangeLower: Range<UInt32> = 97..<123
            return letterAsciiRangeLower.contains(val) || letterAsciiRangeUpper.contains(val)
        }
        return false
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
    
    
    func matchedLength() -> Int {
        return 0
        // MARK
    }
    
}


// Definition:
extension Notification.Name {
    static let settingsChanged = Notification.Name("settingsForPep9AndPep9CPUChanged")
}


extension UIColor {
    
    func lighter(_ amount : CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    func darker(_ amount : CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    fileprivate func hueColorWithBrightnessAmount(_ amount: CGFloat) -> UIColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor( hue: hue,
                            saturation: saturation,
                            brightness: brightness * amount,
                            alpha: alpha )
        } else {
            return self
        }
        
    }
}




public extension CGFloat {
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}

extension UIView {
    func addBorder() {
        self.layer.borderColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
    }
    
    func removeBorder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
    }

}

// This doesn't work, probably because of missized output textView
//extension UITextView {
//    func scrollToBottom() {
//        let bottom = self.contentSize.height - self.bounds.size.height
//        self.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
//    }
//}










