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
    
    func setupTextView(frame: CGRect) {
        let rect = CGRectMake(frame.origin.x, frame.origin.y, 0.70*(superview?.bounds.width)!, superview!.bounds.height/2)
        self.textStorage = PepTextStorage()
        self.layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        self.textContainer = NSTextContainer()
        self.layoutManager.addTextContainer(textContainer)
        self.textView = UITextView(frame: rect, textContainer: textContainer)
        textView.showsVerticalScrollIndicator = true
        self.addSubview(textView)
        
//        self.font = UIFont(name: Courier, size: 16)
//        self.directionalLockEnabled = true
//        self.textAlignment = .Left
    }
    

// MARK: - Text-Handling Functions
    internal func loadText(text: String) {
        self.textView.text = text
    }
    
    func loadExample(fileName: String, ofType: PepFileType) {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: ofType.rawValue) else {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //TODO: Implement
        return true
    }
    
    
    
}
