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
}
