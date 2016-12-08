//
//  Extensions.swift
//  pep9pad
//
//  Created by Josh Haug on 12/1/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

extension Bool {
    func toIntString() -> String {
        return self == true ? "1" : "0"
    }
}

extension Int {
    func toHex4() -> String {
        return String(format:"%04X", self)
    }
    
    func toBin8() -> String {
        var str = String(self, radix: 2)
        let len = str.characters.count
        if len > 8 {
            return "EEEEEEEE"
        }
        return String(repeating: "0", count: 8-str.characters.count) + str
    }
}
