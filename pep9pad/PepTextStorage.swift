//
//  PepTextStorage.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class PepTextStorage: BaseTextStorage {
    
    internal var patterns: NSDictionary!
    internal var regularExpressions: [NSRegularExpression] = []
    internal var highlightAs: HighlightableLanguage! = .other
    
    override func processEditing() {
        let text = string as NSString
        let attributes : [String:AnyObject]? = [
            NSFontAttributeName : UIFont(name: Courier, size: 18)!
        ]
        
        setAttributes(attributes, range: NSRange(location: 0, length: length))
        
//        text.enumerateSubstringsInRange(NSRange(location: 0, length: length), options: .ByWords) { [weak self] string, range, _, _ in
//            guard let string = string else { return }
//      
        
        if highlightAs == .other {
            super.processEditing()
            return
        }
        
        // Loading `regularExpressions` from `Pep/CppHighlightingPatterns.plist` if needed.
        if regularExpressions.count == 0 {
            self.setupHighlightPatterns(Bundle.main.path(forResource: "\(highlightAs.rawValue)HighlightingPatterns", ofType: "plist"))
        }
        // Now find matches
        if text != "" {
            // useful for debugging syntax highlighting
            // print("Text found to be legal, proceeding with regex.")
            for regex in regularExpressions {
                let patternName = patterns.allKeys(for: regex.pattern)[0] as! String
                var arrayOfResults: [NSTextCheckingResult] = []
                
                do {
                    let results = regex.matches(in: String(text), options: [], range: NSMakeRange(0, text.length))
                    for str in results {
                        arrayOfResults.append(str)
                    }
                    // useful for debugging syntax highlighting
                    // print("Check for \(patternName) produced \(arrayOfResults.count) results with text len == \(text.length).")
                } catch let error as NSError {
                    // useful for debugging syntax highlighting
                    // print("Invalid regex: \(error.localizedDescription)")
                } catch {
                    // useful for debugging syntax highlighting
                    // print("Unknown regex error in PepTextStorage.")
                }

                if arrayOfResults.count > 0 {
                    self.highlightSyntaxPattern(patternName, foundInstances: arrayOfResults)
                }
            }
        } else {
            // useful for debugging syntax highlighting
            // print("Text found to be empty, skipping regex.")
        }

        super.processEditing()
    }
    
    internal func setupHighlightPatterns(_ path: String!) {
        self.patterns = NSDictionary(contentsOfFile: path)
        for pat in patterns {
            do {
                //print("Inputting: \(pat.key) : \(pat.value)")
                regularExpressions.append(try NSRegularExpression(pattern: pat.value as! String, options: []))
            } catch {
                // useful for debugging syntax highlighting
                // print("Not all syntax highlight patterns were set.")
            }
        }
    }
    
    func highlightAs(_ lang: HighlightableLanguage) {
        if lang != highlightAs {
            highlightAs = lang
            regularExpressions.removeAll()
        }
    }
    
    internal func highlightSyntaxPattern(_ nameOfPattern: String, foundInstances: [NSTextCheckingResult]) {
        let attributes: [String:AnyObject]
        
        switch nameOfPattern {
        case "operator":
            // Operators are blue, bold, and capitalized.
            attributes = [
                NSForegroundColorAttributeName:blueColor,
                NSFontAttributeName:UIFont(name: CourierBold, size: 18)!
            ]
        case "dot", "keyword":
            // Dot commands are blue, italicized, and capitalized.
            attributes = [
                NSForegroundColorAttributeName:blueColor,
                NSFontAttributeName:UIFont(name: CourierItalic, size: 18)!
            ]
        case "singleLineComment", "comment", "documentation_comment":
            // Comments are green.
            // TODO: Fix this green to match the green in Pep/9.
            attributes = [
                NSForegroundColorAttributeName:greenColor
            ]
        case "symbol":
            // Symbols are purple and bold.
            attributes = [
                NSForegroundColorAttributeName:purpleColor,
                NSFontAttributeName:UIFont(name: CourierBold, size: 18)!

            ]
        case "singleQuote", "doubleQuote", "string" :
            // Text in quotes is red.
            attributes = [
                NSForegroundColorAttributeName:redColor
            ]
        case "warning":
            // Warnings have a blue background.
            attributes = [
                NSForegroundColorAttributeName:whiteColor,
                NSBackgroundColorAttributeName:blueColor
            ]
        case "error":
            // Errors have a red background.
            attributes = [
                NSForegroundColorAttributeName:whiteColor,
                NSBackgroundColorAttributeName:redColor
            ]
        default:
            attributes = [NSForegroundColorAttributeName:UIColor.orange]
        }
        
        for instance in foundInstances {
            //print("Found \(nameOfPattern) at \(instance.range)")
            self.addAttributes(attributes, range: instance.range)
        }
    }
    
}
