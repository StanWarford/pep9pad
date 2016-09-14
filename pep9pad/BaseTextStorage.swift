//
//  BaseTextStorage.swift
//  pep9pad
//
//  Created by Josh Haug on 5/11/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class BaseTextStorage: NSTextStorage {
    
    // MARK: - Properties
    fileprivate let storage = NSMutableAttributedString()
    
    // MARK: - NSTextStorage
    override var string: String {
        return storage.string
    }
    
    override func attributes(at location: Int, effectiveRange: NSRangePointer?) -> [String : Any] {
        return storage.attributes(at: location, effectiveRange: effectiveRange)
    }
    
    override func replaceCharacters(in range: NSRange, with string: String) {
        let beforeLength = length
        storage.replaceCharacters(in: range, with: string)
        edited(.editedCharacters, range: range, changeInLength: length - beforeLength)
        
    }
    
    override func setAttributes(_ attributes: [String : Any]?, range: NSRange) {
        storage.setAttributes(attributes, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
}
