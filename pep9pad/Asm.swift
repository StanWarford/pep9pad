//
//  File.swift
//  pep9pad
//
//  Created by Josh Haug on 4/13/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class Asm: NSObject {
    /// Lexical tokens
    enum ELexicalToken {
        case LT_ADDRESSING_MODE
        case LT_CHAR_CONSTANT
        case LT_COMMENT
        case LT_DEC_CONSTANT
        case LT_DOT_COMMAND
        case LT_EMPTY
        case LT_HEX_CONSTANT
        case LT_IDENTIFIER
        case LT_STRING_CONSTANT
        case LT_SYMBOL_DEF
    }
    
    enum ParseState {
        case PS_ADDRESSING_MODE
        case PS_CLOSE
        case PS_COMMENT
        case PS_DOT_ADDRSS
        case PS_DOT_ALIGN
        case PS_DOT_ASCII
        case PS_DOT_BLOCK
        case PS_DOT_BURN
        case PS_DOT_BYTE
        case PS_DOT_END
        case PS_DOT_EQUATE
        case PS_DOT_WORD
        case PS_FINISH
        case PS_INSTRUCTION
        case PS_START
        case PS_STRING
        case PS_SYMBOL_DEF
    }
    
    // MARK: - Regular Expressions -
    
    // MARK: Regular expressions for lexical analysis
    // NOTE: the following variables use the `try!` modifier to force a pattern-matching attempt. `NSRegularExpression` throws an error if the pattern is invalid. Our patterns are fixed and thus will never `throw` an error.
    let rxAddrMode = try! NSRegularExpression(pattern: "^((,)(\\s*)(i|d|x|n|s(?![fx])|sx(?![f])|sf|sfx){1}){1}", options: [.CaseInsensitive])
    let rxCharConst = try! NSRegularExpression(pattern: "^((\')(?![\'])(([^\'\\\\]){1}|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))(\'))", options: [.CaseInsensitive])
    let rxComment = try! NSRegularExpression(pattern: "^((;{1})(.)*)", options: [.CaseInsensitive])
    let rxDecConst = try! NSRegularExpression(pattern: "^((([+|-]{0,1})([0-9]+))|^(([1-9])([0-9]*)))", options: [.CaseInsensitive])
    let rxDotCommand = try! NSRegularExpression(pattern: "^((.)(([A-Z|a-z]{1})(\\w)*))", options: [.CaseInsensitive])
    let rxHexConst = try! NSRegularExpression(pattern: "^((0(?![x|X]))|((0)([x|X])([0-9|A-F|a-f])+)|((0)([0-9]+)))", options: [.CaseInsensitive])
    let rxIdentifier = try! NSRegularExpression(pattern: "^((([A-Z|a-z|_]{1})(\\w*))(:){0,1})", options: [.CaseInsensitive])
    let rxStringConst = try! NSRegularExpression(pattern: "^((\")((([^\"\\\\])|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))*)(\"))", options: [.CaseInsensitive])
    
    // MARK: Regular expressions for trace tag analysis
    let rxFormatTag = try! NSRegularExpression(pattern: "(#((1c)|(1d)|(1h)|(2d)|(2h))((\\d)+a)?(\\s|$))", options: [.CaseInsensitive])
    let rxSymbolTag = try! NSRegularExpression(pattern: "#([a-zA-Z][a-zA-Z0-9]{0,7})", options: [.CaseInsensitive])
    let rxArrayMultiplier = try! NSRegularExpression(pattern: "((\\d)+)a", options: [.CaseInsensitive])
}
