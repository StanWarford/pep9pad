//
//  PepTextStorage.swift
//  pep9pad
//
//  Created by Josh Haug on 5/11/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class PepTextStorage: BaseTextStorage {
    
    internal var patterns: NSDictionary!
    internal var regularExpressions: [NSRegularExpression] = []
    
    override func processEditing() {
        let text = string as NSString
        let attributes : [String:AnyObject]? = [
            NSFontAttributeName : UIFont(name: Courier, size: 18)!
        ]
        
        setAttributes(attributes, range: NSRange(location: 0, length: length))
        
//        text.enumerateSubstringsInRange(NSRange(location: 0, length: length), options: .ByWords) { [weak self] string, range, _, _ in
//            guard let string = string else { return }
//      
        // Loading `regularExpressions` from `PepHighlightingPatterns.plist` if needed.
        if regularExpressions.count == 0 {
            self.setupHighlightPatterns(NSBundle.mainBundle().pathForResource("PepHighlightingPatterns", ofType: "plist"))
        }
        if text != "" {
            print("Text found to be legal, proceeding with regex.")
            for regex in regularExpressions {
                let patternName = patterns.allKeysForObject(regex.pattern)[0] as! String
                var arrayOfResults: [NSTextCheckingResult] = []
                
                do {
                    let results = regex.matchesInString(String(text), options: [], range: NSMakeRange(0, text.length))
                    for str in results {
                        arrayOfResults.append(str)
                    }
                    print("Check for \(patternName) produced \(arrayOfResults.count) results with text len == \(text.length).")
                } catch let error as NSError {
                    print("invalid regex: \(error.localizedDescription)")
                } catch {
                    print("Another error")
                }

                if arrayOfResults.count > 0 {
                    self.highlightSyntaxPattern(patternName, foundInstances: arrayOfResults)
                }
            }
        } else {
            print("Text found to be EMPTY, skipping regex!")
        }

        super.processEditing()
    }
    
    internal func setupHighlightPatterns(path: String!) {
        self.patterns = NSDictionary(contentsOfFile: path)
        for pat in patterns {
            do {
                //print("Inputting: \(pat.key) : \(pat.value)")
                regularExpressions.append(try NSRegularExpression(pattern: pat.value as! String, options: []))
            } catch {
                print("Error")
            }
        }
    }
    
    internal func highlightSyntaxPattern(nameOfPattern: String, foundInstances: [NSTextCheckingResult]) {
        let attributes: [String:AnyObject]
        
        switch nameOfPattern {
        case "operator":
            // Operators are blue, bold, and capitalized.
            attributes = [
                NSForegroundColorAttributeName:blueColor,
                NSFontAttributeName:UIFont(name: CourierBold, size: 18)!
            ]
        case "dot":
            // Dot commands are blue, italicized, and capitalized.
            attributes = [
                NSForegroundColorAttributeName:blueColor,
                NSFontAttributeName:UIFont(name: CourierItalic, size: 18)!
            ]
        case "singleLineComment":
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
        case "singleQuote", "doubleQuote" :
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
            attributes = [NSForegroundColorAttributeName:UIColor.orangeColor()]
        }
        
        for instance in foundInstances {
            //print("Found \(nameOfPattern) at \(instance.range)")
            self.addAttributes(attributes, range: instance.range)
        }
    }
    
}