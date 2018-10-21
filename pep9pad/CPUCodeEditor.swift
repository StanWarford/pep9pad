//
//  CPUCodeEditor.swift
//  pep9pad
//
//  Created by David Nicholas on 10/19/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

//class CPUCodeEditor: UITextView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}
protocol CPUCodeEditorDelegate: class {
    func didUpdateCursorFloatingState()
}

class CPUCodeEditor: UITextView {
    
    weak var editorDelegate: CPUCodeEditorDelegate?
    var theme: SyntaxColorTheme? = cpuTheme()
    var cachedParagraphs: [Paragraph]?
    
    func invalidateCachedParagraphs() {
        cachedParagraphs = nil
    }
    
    func hideGutter() {
        gutterWidth = theme?.gutterStyle.minimumWidth ?? 0.0
    }
    
    func updateGutterWidth(for numberOfCharacters: Int) {
        let leftInset: CGFloat = 4.0
        let rightInset: CGFloat = 4.0
        let charWidth: CGFloat = 10.0
        
        gutterWidth = max(theme?.gutterStyle.minimumWidth ?? 0.0, CGFloat(numberOfCharacters) * charWidth + leftInset + rightInset)
    }
    
    #if os(iOS)
    var isCursorFloating = false
    
    override func beginFloatingCursor(at point: CGPoint) {
        super.beginFloatingCursor(at: point)
        
        isCursorFloating = true
        editorDelegate?.didUpdateCursorFloatingState()
        
    }
    
    override func endFloatingCursor() {
        super.endFloatingCursor()
        
        isCursorFloating = false
        editorDelegate?.didUpdateCursorFloatingState()
        
    }
    
    override public func draw(_ rect: CGRect) {
        
        guard let theme = theme else {
            super.draw(rect)
            hideGutter()
            return
        }
        
        let textView = self
        if theme.lineNumbersStyle == nil  {
            
            hideGutter()
            
            let gutterRect = CGRect(x: 0, y: rect.minY, width: textView.gutterWidth, height: rect.height)
            let path = UIBezierPath(rect: gutterRect)
            path.fill()

        } else {
            
            let components = textView.text.components(separatedBy: .newlines)
            let count = components.count
            let maxNumberOfDigits = "\(count)".count
            
            textView.updateGutterWidth(for: maxNumberOfDigits)
            
            var paragraphs: [Paragraph]
            
            if let cached = textView.cachedParagraphs {
                paragraphs = cached
            } else {
                paragraphs = generateParagraphs(for: textView, flipRects: false)
                textView.cachedParagraphs = paragraphs
            }
            
            theme.gutterStyle.backgroundColor.setFill()
            
            let gutterRect = CGRect(x: 0, y: rect.minY, width: textView.gutterWidth, height: rect.height)
            let path = UIBezierPath(rect: gutterRect)
            path.fill()
            
            drawLineNumbers(paragraphs, in: rect, for: self)
            
        }
        super.draw(rect)
        
    }
    #endif
    
    var gutterWidth: CGFloat {
        set {
            #if os(macOS)
            textContainerInset = NSSize(width: newValue, height: 0)
            #else
            textContainerInset = UIEdgeInsets(top: 0, left: newValue, bottom: 0, right: 0)
            #endif
        }
        get {
            #if os(macOS)
            return textContainerInset.width
            #else
            return textContainerInset.left
            #endif
        }
    }
    
    #if os(iOS)
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        
        guard let theme = theme else {
            return superRect
        }
        
        let font = theme.font
        
        // "descender" is expressed as a negative value,
        // so to add its height you must subtract its value
        superRect.size.height = font.pointSize - font.descender
        
        return superRect
    }
    
    #endif
    
    func pepHighlighter(busSize : CPUBusSize){
        let codeEditor = self
        let codeEditorText = self.text
        
        let attributedText = codeEditor.attributedText.mutableCopy() as! NSMutableAttributedString
        
        let attributedTextRange = NSMakeRange(0, attributedText.length)
        attributedText.removeAttribute(NSAttributedString.Key.foregroundColor, range: attributedTextRange)
        
        //Numbers
        if let regex = try? NSRegularExpression(pattern: "(0x)?[0-9a-fA-F]+(?=(,|;|(\\s)*$|\\]|(\\s)*//))", options: .caseInsensitive){
            let range = NSRange(codeEditor.text.startIndex..., in: codeEditorText!)
            let matches = regex.matches(in: codeEditorText!, options: [], range: range)
            
            for match in matches {
                let matchRange = match.range
                //let string = codeEditorText!.sub
                
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: matchRange)
               
            }
             codeEditor.attributedText = (attributedText.copy() as! NSAttributedString)
            
        }
        //The oprnds
        let oprndPattern = "\\bLoadCk\\b|\\bC\\b|\\bB\\b|\\bA\\b|\\bMARCk\\b|\\bMDRCk\\b|\\bAMux\\b|\\bMDRMux\\b|\\bCMux\\b|\\bALU\\b|\\bCSMux\\b|\\bSCk\\b|\\bCCk\\b|\\bVCk\\b|\\bAndZ\\b|\\bZCk\\b|\\bNCk\\b|\\bMemRead\\b|\\bMemWrite\\b|^(\\s)*UnitPre(?=:)\\b|^(\\s)*UnitPost(?=:)\\b|\\bN\\b|\\bZ\\b|\\bV\\b|\\bS\\b|\\bX\\b|\\bSP\\b|\\bPC\\b|\\bIR\\b|\\bT1\\b|\\bT2\\b|\\bT3\\b|\\bT4\\b|\\bT5\\b|\\bT6\\b|\\bMem\\b" //: "\\bLoadCk\\b|\\bC\\b|\\bB\\b|\\bA\\b|\\bMARCk\\b|\\bMARMux\\b|\\bMDROCk\\b|\\bMDRECk\\b|\\bMDROMux\\b|\\bMDREMux\\b|\\bEOMux\\b|\\bCMux\\b|\\bAMux\\|\\bALU\\b|\\bCSMux\\b|\\bSCk\\b|\\bCCk\\b|\\bVCk\\b|\\bAndZ\\b|\\bZCk\\b|\\bNCk\\b|\\bMemRead\\b|\\bMemWrite\\b|^(\\s)*UnitPre(?=:)\\b|^(\\s)*UnitPost(?=:)\\b|\\bN\\b|\\bZ\\b|\\bV\\b|\\bS\\b|\\bX\\b|\\bSP\\b|\\bPC\\b|\\bIR\\b|\\bT1\\b|\\bT2\\b|\\bT3\\b|\\bT4\\b|\\bT5\\b|\\bT6\\b|\\bMem\\b"

        if let regex = try? NSRegularExpression(pattern: oprndPattern, options: .caseInsensitive){
            let range = NSRange(codeEditor.text.startIndex..., in: codeEditorText!)
            let matches = regex.matches(in: codeEditorText!, options: [], range: range)

            for match in matches {
                let matchRange = match.range
                //let string = codeEditorText!.sub

                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: matchRange)
                //attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize), range: matchRange)

            }
            codeEditor.attributedText = (attributedText.copy() as! NSAttributedString)

        }

        //Comments
        if let regex = try? NSRegularExpression(pattern: "//.*", options: .caseInsensitive){
            let range = NSRange(codeEditor.text.startIndex..., in: codeEditorText!)
            let matches = regex.matches(in: codeEditorText!, options: [], range: range)
            
            for match in matches {
                let matchRange = match.range
                
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.CPUColors.bitBusColor, range: matchRange)
                
            }
            codeEditor.attributedText = (attributedText.copy() as! NSAttributedString)
            
        }
        
        
    }
    
}

struct Paragraph {
    
    var rect: CGRect
    let number: Int
    
    var string: String {
        return (number == -1 ? "" : "\(number)")
    }
    func attributedString(for style: LineNumbersStyle) -> NSAttributedString {
        
        let attr = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attr.length)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .foregroundColor : style.textColor
        ]
        
        attr.addAttributes(attributes, range: range)
        
        return attr
    }
    func drawSize(for style: LineNumbersStyle) -> CGSize {
        return attributedString(for: style).size()
    }
}

public struct LineNumbersStyle {
    
    public let font: UIFont
    public let textColor: UIColor
    
    public init(font: UIFont, textColor: UIColor) {
        self.font = font
        self.textColor = textColor
    }
    
}

public struct GutterStyle {
    
    public let backgroundColor: UIColor
    
    /// If line numbers are displayed, the gutter width adapts to fit all line numbers.
    /// This specifies the minimum width that the gutter should have at all times
    /// regardless of any line numbers.
    public let minimumWidth: CGFloat
    
    public init(backgroundColor: UIColor, minimumWidth: CGFloat) {
        self.backgroundColor = backgroundColor
        self.minimumWidth = minimumWidth
    }
}

public protocol SyntaxColorTheme {
    
    /// Nil hides line numbers.
    var lineNumbersStyle: LineNumbersStyle? { get }
    
    var gutterStyle: GutterStyle { get }
    
    var font: UIFont { get }
    
    var backgroundColor: UIColor { get }
    
    //func globalAttributes() -> [NSAttributedString.Key: Any]
    
    //func attributes(for token: Token) -> [NSAttributedString.Key: Any]
}

struct cpuTheme : SyntaxColorTheme {
    var lineNumbersStyle: LineNumbersStyle?
    
    var gutterStyle: GutterStyle
    
    var font: UIFont
    
    var backgroundColor: UIColor
    
    //    func globalAttributes() -> [NSAttributedString.Key : Any] {
    //
    //    }
    
    init(){
        lineNumbersStyle = LineNumbersStyle(font: UIFont(name: "CourierNewPS-BoldMT", size: UIFont.systemFontSize)!, textColor: UIColor.darkGray)
        gutterStyle = GutterStyle(backgroundColor: UIColor.lightGray, minimumWidth: 30)
        font = UIFont(name: "CourierNewPS-BoldMT", size: UIFont.systemFontSize)!
        backgroundColor = UIColor.white
    }
}


extension UITextView {
    
    func paragraphRectForRange(range: NSRange) -> CGRect {
        
        var nsRange = range
        
        let layoutManager: NSLayoutManager
        let textContainer: NSTextContainer
        #if os(macOS)
        layoutManager = self.layoutManager!
        textContainer = self.textContainer!
        #else
        layoutManager = self.layoutManager
        textContainer = self.textContainer
        #endif
        
        nsRange = layoutManager.glyphRange(forCharacterRange: nsRange, actualCharacterRange: nil)
        
        var sectionRect = layoutManager.boundingRect(forGlyphRange: nsRange, in: textContainer)
        
        // FIXME: don't use this hack
        // This gets triggered for the final paragraph in a textview if the next line is empty (so the last paragraph ends with a newline)
        if sectionRect.origin.x == 0 {
            sectionRect.size.height -= 22
        }
        
        sectionRect.origin.x = 0
        
        return sectionRect
    }
    
}

func generateParagraphs(for textView: CPUCodeEditor, flipRects: Bool = false) -> [Paragraph] {
    
    let range = NSRange(location: 0, length: (textView.text as NSString).length)
    
    
    var paragraphs = [Paragraph]()
    var i = 0
    //let pat = ""
    (textView.text as NSString).enumerateSubstrings(in: range, options: [.byParagraphs]) { (paragraphContent, paragraphRange, enclosingRange, stop) in
         var line = false //!//(paragraphContent?.first == "/" || paragraphContent?.first == nil)
        if let regex = try? NSRegularExpression(pattern: "^\\s*//|^\\s*$|^\\s*unitpre|^\\s*unitpost", options: .caseInsensitive) {
                if regex.matchesIn(paragraphContent!).isEmpty{
                    line = true
                }
            }
       
        //print(paragraphContent?.first)
        if line {
            i += 1
            
            let rect = textView.paragraphRectForRange(range: paragraphRange)
            
            
            let paragraph = Paragraph(rect: rect, number: i)
            
            paragraphs.append(paragraph)
        }else{
            let rect = textView.paragraphRectForRange(range: paragraphRange)
            
            let paragraph = Paragraph(rect: rect, number: -1)
            paragraphs.append(paragraph)
        }
        
        
        
    }
    
    if textView.text.isEmpty || textView.text.hasSuffix("\n") {
        
        var rect: CGRect
        
        #if os(macOS)
        let gutterWidth = textView.textContainerInset.width
        #else
        let gutterWidth = textView.textContainerInset.left
        #endif
        
        let lineHeight: CGFloat = 18
        
        if let last = paragraphs.last {
            
            // FIXME: don't use hardcoded "2" as line spacing
            rect = CGRect(x: 0, y: last.rect.origin.y + last.rect.height + 2, width: gutterWidth, height: last.rect.height)
            
        } else {
            
            rect = CGRect(x: 0, y: 0, width: gutterWidth, height: lineHeight)
            
        }
        
        
        i += 1
        let endParagraph = Paragraph(rect: rect, number: i)
        paragraphs.append(endParagraph)
        
    }
    
    
    if flipRects {
        
        paragraphs = paragraphs.map { (p) -> Paragraph in
            
            var p = p
            p.rect.origin.y = textView.bounds.height - p.rect.height - p.rect.origin.y
            
            return p
        }
        
    }
    
    return paragraphs
}

func offsetParagraphs(_ paragraphs: [Paragraph], for textView: CPUCodeEditor, yOffset: CGFloat = 0) -> [Paragraph] {
    
    var paragraphs = paragraphs
    
    #if os(macOS)
    
    if let yOffset = textView.enclosingScrollView?.contentView.bounds.origin.y {
        
        paragraphs = paragraphs.map { (p) -> Paragraph in
            
            var p = p
            p.rect.origin.y += yOffset
            
            return p
        }
    }
    
    
    #endif
    
    
    
    paragraphs = paragraphs.map { (p) -> Paragraph in
        
        var p = p
        p.rect.origin.y += yOffset
        return p
    }
    
    return paragraphs
}

func drawLineNumbers(_ paragraphs: [Paragraph], in rect: CGRect, for textView: CPUCodeEditor) {
    
    guard let style = textView.theme?.lineNumbersStyle else {
        return
    }
    
    for paragraph in paragraphs {
        
        guard paragraph.rect.intersects(rect) else {
            continue
        }
        
        let attr = paragraph.attributedString(for: style)
        
        var drawRect = paragraph.rect
        
        let gutterWidth = textView.gutterWidth
        
        let drawSize = attr.size()
        
        drawRect.origin.x = gutterWidth - drawSize.width - 4
        
        #if os(macOS)
        //            drawRect.origin.y += (drawRect.height - drawSize.height) / 2.0
        #else
        //            drawRect.origin.y += 22 - drawSize.height
        #endif
        drawRect.size.width = drawSize.width
        drawRect.size.height = drawSize.height
        
        //        Color.red.withAlphaComponent(0.4).setFill()
        //        paragraph.rect.fill()
        
        attr.draw(in: drawRect)
        
    }
    
}

