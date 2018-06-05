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
        let attributes : [NSAttributedStringKey:AnyObject]? = [
            NSAttributedStringKey.font : UIFont(name: Courier, size: appSettings.fontSize)!,
            NSAttributedStringKey.foregroundColor: appSettings.darkModeOn ? UIColor(red:0.99, green:0.96, blue:0.89, alpha:1.0) : UIColor(red:0.00, green:0.17, blue:0.21, alpha:1.0)
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
                }
                //catch _ as NSError {
                //                    // useful for debugging syntax highlighting
                //                    // print("Invalid regex: \(error.localizedDescription)")
                //                } catch {
                //                    // useful for debugging syntax highlighting
                //                    // print("Unknown regex error in PepTextStorage.")
                //                }

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
                regularExpressions.append(try NSRegularExpression(pattern: pat.value as! String, options: [.anchorsMatchLines]))
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
        let attributes: [NSAttributedStringKey:AnyObject]
        
        switch nameOfPattern {
        case "operator":
            // Operators are blue, bold, and capitalized.
            attributes = [
                NSAttributedStringKey.foregroundColor:blueColor,
                NSAttributedStringKey.font:UIFont(name: CourierBold, size: appSettings.fontSize)!
            ]
        case "dot", "keyword":
            // Dot commands are blue, italicized, and capitalized.
            attributes = [
                NSAttributedStringKey.foregroundColor:blueColor,
                NSAttributedStringKey.font:UIFont(name: CourierItalic, size: appSettings.fontSize)!
            ]
        case "singleLineComment", "comment", "documentation_comment":
            // Comments are grey.
            attributes = [
                NSAttributedStringKey.foregroundColor:greyColor
            ]
        case "symbol":
            // Symbols are green and bold.
            attributes = [
                NSAttributedStringKey.foregroundColor:greenColor,
                NSAttributedStringKey.font:UIFont(name: CourierBold, size: appSettings.fontSize)!
            ]
        case "singleQuote", "doubleQuote", "string" :
            // Text in quotes is cyan.
            attributes = [
                NSAttributedStringKey.foregroundColor:cyanColor
            ]
        case "warning":
            // Warnings have an orange background.
            attributes = [
                NSAttributedStringKey.foregroundColor:whiteColor,
                NSAttributedStringKey.backgroundColor:orangeColor
            ]
        case "error":
            // Errors have a red background.
            attributes = [
                NSAttributedStringKey.foregroundColor:whiteColor,
                NSAttributedStringKey.backgroundColor:redColor
            ]
        default:
            attributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        }
        
        for instance in foundInstances {
            //print("Found \(nameOfPattern) at \(instance.range)")
            self.addAttributes(attributes, range: instance.range)
        }
    }
    
}
