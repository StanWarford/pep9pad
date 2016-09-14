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
        case lt_ADDRESSING_MODE
        case lt_CHAR_CONSTANT
        case lt_COMMENT
        case lt_DEC_CONSTANT
        case lt_DOT_COMMAND
        case lt_EMPTY
        case lt_HEX_CONSTANT
        case lt_IDENTIFIER
        case lt_STRING_CONSTANT
        case lt_SYMBOL_DEF
    }
    
    enum ParseState {
        case ps_ADDRESSING_MODE
        case ps_CLOSE
        case ps_COMMENT
        case ps_DOT_ADDRSS
        case ps_DOT_ALIGN
        case ps_DOT_ASCII
        case ps_DOT_BLOCK
        case ps_DOT_BURN
        case ps_DOT_BYTE
        case ps_DOT_END
        case ps_DOT_EQUATE
        case ps_DOT_WORD
        case ps_FINISH
        case ps_INSTRUCTION
        case ps_START
        case ps_STRING
        case ps_SYMBOL_DEF
    }
    
    // MARK: - Regular Expressions -
    
    // MARK: Regular expressions for lexical analysis
    // NOTE: the following variables use the `try!` modifier to force a pattern-matching attempt. `NSRegularExpression` throws an error if the pattern is invalid. Our patterns are fixed and thus will never `throw` an error.
    let rxAddrMode = try! NSRegularExpression(pattern: "^((,)(\\s*)(i|d|x|n|s(?![fx])|sx(?![f])|sf|sfx){1}){1}", options: [.caseInsensitive])
    let rxCharConst = try! NSRegularExpression(pattern: "^((\')(?![\'])(([^\'\\\\]){1}|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))(\'))", options: [.caseInsensitive])
    let rxComment = try! NSRegularExpression(pattern: "^((;{1})(.)*)", options: [.caseInsensitive])
    let rxDecConst = try! NSRegularExpression(pattern: "^((([+|-]{0,1})([0-9]+))|^(([1-9])([0-9]*)))", options: [.caseInsensitive])
    let rxDotCommand = try! NSRegularExpression(pattern: "^((.)(([A-Z|a-z]{1})(\\w)*))", options: [.caseInsensitive])
    let rxHexConst = try! NSRegularExpression(pattern: "^((0(?![x|X]))|((0)([x|X])([0-9|A-F|a-f])+)|((0)([0-9]+)))", options: [.caseInsensitive])
    let rxIdentifier = try! NSRegularExpression(pattern: "^((([A-Z|a-z|_]{1})(\\w*))(:){0,1})", options: [.caseInsensitive])
    let rxStringConst = try! NSRegularExpression(pattern: "^((\")((([^\"\\\\])|((\\\\)([\'|b|f|n|r|t|v|\"|\\\\]))|((\\\\)(([x|X])([0-9|A-F|a-f]{2}))))*)(\"))", options: [.caseInsensitive])
    
    // MARK: Regular expressions for trace tag analysis
    let rxFormatTag = try! NSRegularExpression(pattern: "(#((1c)|(1d)|(1h)|(2d)|(2h))((\\d)+a)?(\\s|$))", options: [.caseInsensitive])
    let rxSymbolTag = try! NSRegularExpression(pattern: "#([a-zA-Z][a-zA-Z0-9]{0,7})", options: [.caseInsensitive])
    let rxArrayMultiplier = try! NSRegularExpression(pattern: "((\\d)+)a", options: [.caseInsensitive])
}
