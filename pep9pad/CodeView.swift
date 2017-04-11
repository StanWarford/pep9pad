//
//  CodeView.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.

import UIKit

class CodeView: UIView, UITextViewDelegate {
    
    internal var textStorage: PepTextStorage!
    internal var layoutManager: NSLayoutManager!
    internal var textContainer: NSTextContainer!
    internal var textView: UITextView!
    internal var delegate: CodeViewDelegate!
    
    // MARK: - Initializers and Set-up Functions
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTextView(_ frame: CGRect, delegate: CodeViewDelegate! = nil, highlightAs: HighlightableLanguage = .other) {
        self.delegate = delegate
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        textStorage = PepTextStorage()
        textStorage.highlightAs(highlightAs)
        layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        textView = UITextView(frame: rect, textContainer: textContainer)
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        self.addSubview(textView)
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = true // MARK: Not all the time, put in initializer
        textView.delegate = self
        textView.isSelectable = true
        textView.font = UIFont(name: Courier, size: appSettings.fontSize)
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CodeView.settingsChanged), name: .settingsChanged, object: nil)
        
        settingsChanged()
//        self.font = UIFont(name: Courier, size: 16)
//        self.directionalLockEnabled = true
//        self.textAlignment = .Left
    }
    
    
    func setEditable(_ to: Bool) {
        textView.isEditable = to
    }
    
    func setHighlight(_ lang: HighlightableLanguage) {
        textStorage.highlightAs(lang)
    }
    
    func setHighlight(_ forType: PepFileType) {
        switch forType {
        case .pep, .pepl, .pepo, .pepb, .peph:
            textStorage.highlightAs(.pep)
        case .c:
            textStorage.highlightAs(.c)
        default:
            textStorage.highlightAs(.other)
        }
    }
    
    func settingsChanged() {
        
        textView.font = UIFont(name: Courier, size: appSettings.fontSize)
        textView.backgroundColor = appSettings.getColorFor(.background)
        textView.textColor = appSettings.getColorFor(.text)
        //textView.font = textView.font?.withSize(appSettings.fontSize)
        // TODO: change foreground and background color to match the scheme in appSettings
    }
    
    
    
    // MARK: - Text-Handling Functions
    
    internal func setText(_ to: String) {
        self.textView.text = to
    }
    
    
    func removeAllText() {
        textView.text.removeAll()
    }
    
    func getText() -> String {
        return textView.text
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
    

    // MARK: - Conformance to UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if delegate != nil {
            delegate.textViewDidChange()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Ensure we're not at the start of the text field and we are inserting text -- this is only to disable the ``double space adds perio`` shortcut that Apple enabled.
        if range.location > 0 && text.characters.count > 0 {
            let whitespace = NSCharacterSet.whitespaces
            let utf16text = text.utf16
            let utf16textViewText = textView.text.utf16
            
            let startIndex = utf16text.startIndex
            let locationIndex = utf16textViewText.startIndex.advanced(by: range.location - 1)
            
            //Check if a space follows a space
            if whitespace.contains(UnicodeScalar(utf16text[startIndex])!) && whitespace.contains(UnicodeScalar(utf16textViewText[locationIndex])!) {
                //Manually replace the space with your own space, programmatically
                textView.text = (textView.text as NSString).replacingCharacters(in: range, with: " ")
                //Make sure you update the text caret to reflect the programmatic change to the text view
                textView.selectedRange = NSMakeRange(range.location + 1, 0)
                
                //Tell UIKit not to insert its space, because you've just inserted your own
                return false
            }
        }
        
        return true
    }

    
    
    
    
    
}
