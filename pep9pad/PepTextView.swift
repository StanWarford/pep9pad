//
//  PepTextView.swift
//  pep9pad
//
//  Created by Josh Haug on 3/14/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.

import UIKit

class PepTextView: UIView, UITextViewDelegate {
    
    internal var textStorage: PepTextStorage!
    internal var layoutManager: NSLayoutManager!
    internal var textContainer: NSTextContainer!
    internal var textView: UITextView!
    
    
// MARK: - Initializers and Set-up Functions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTextView(_ frame: CGRect) {
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: 0.70*(superview?.bounds.width)!, height: superview!.bounds.height)
        self.textStorage = PepTextStorage()
        self.layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        self.textContainer = NSTextContainer()
        self.layoutManager.addTextContainer(textContainer)
        self.textView = UITextView(frame: rect, textContainer: textContainer)
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        self.addSubview(textView)
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = true


        
//        self.font = UIFont(name: Courier, size: 16)
//        self.directionalLockEnabled = true
//        self.textAlignment = .Left
    }
    

// MARK: - Text-Handling Functions
    internal func setText(_ to: String) {
        self.textView.text = to
    }
    
    func loadExample(_ fileName: String, ofType: PepFileType) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: ofType.rawValue) else {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            print("Loaded file named \(fileName).\(ofType.rawValue)")
            self.textView.text.removeAll()
            self.textView.insertText(content)
        } catch _ as NSError {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
    }
    
    func removeAllText() {
        self.textView.text.removeAll()
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //TODO: Implement
        return true
    }
    
    
    
    
}
