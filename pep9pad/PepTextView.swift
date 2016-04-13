//
//  PepTextView.swift
//  pep9pad
//
//  Created by Josh Haug on 3/14/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class PepTextView: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTextView() {
        self.font = UIFont(name: InconsolataRegular, size: 16)
        self.directionalLockEnabled = true
        self.textAlignment = .Left
    }
    
    internal func loadText(text: String) {
        self.text = text
    }
    
    func loadExample(fileName: String, ofType: PepFileType) {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: ofType.rawValue) else {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            print("Loaded file named \(fileName).\(ofType.rawValue)")
            self.text.removeAll()
            self.insertText(content)
        } catch _ as NSError {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
    }
    
    
    
}
