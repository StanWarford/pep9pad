//
//  CPUMicroAssembler.swift
//  pep9pad
//
//  Created by Josh Haug on 2/13/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

var cpuAssembler = CPUAssemblerModel()

class CPUAssemblerModel {
    
    // All lexical tokens for the CPUAssemblerModel.
    enum ELexicalToken {
        case lt_COMMA
        case lt_COMMENT
        case lt_DIGIT
        case lt_EQUALS
        case lt_EMPTY
        case lt_IDENTIFIER
        case lt_PRE_POST
        case lt_SEMICOLON
        case lt_LEFT_BRACKET
        case lt_RIGHT_BRACKET
        case lt_HEX_CONSTANT
    }
    
    /// The states for the parse FSM for the CPUAssemblerModel.
    enum ParseState {
        case ps_COMMENT
        case ps_CONTINUE_POST_SEMICOLON
        case ps_CONTINUE_PRE_SEMICOLON
        case ps_CONTINUE_PRE_SEMICOLON_POST_COMMA
        case ps_DEC_CONTROL
        case ps_EQUAL_DEC
        case ps_FINISH
        case ps_START
        case ps_START_POST_SEMICOLON
        case ps_START_SPECIFICATION
        case ps_EXPECT_LEFT_BRACKET
        case ps_EXPECT_MEM_ADDRESS
        case ps_EXPECT_RIGHT_BRACKET
        case ps_EXPECT_MEM_EQUALS
        case ps_EXPECT_MEM_VALUE
        case ps_EXPECT_SPEC_COMMA
        case ps_EXPECT_REG_EQUALS
        case ps_EXPECT_REG_VALUE
        case ps_EXPECT_STATUS_EQUALS
        case ps_EXPECT_STATUS_VALUE
    }
    
    // MARK: Regular expressions for lexical analysis.
    // NOTE: the following variables use the `try!` modifier to force a pattern-matching attempt. `NSRegularExpression` throws an error if the pattern is invalid. Our patterns are fixed and thus will never `throw` an error.
    let rxComment = try! NSRegularExpression(pattern: "^//.*", options: [.caseInsensitive])
    let rxDigit = try! NSRegularExpression(pattern: "^[0-9]+", options: [.caseInsensitive])
    let rxIdentifier = try! NSRegularExpression(pattern: "^((([A-Z|a-z]{1})(\\w*))(:){0,1})", options: [.caseInsensitive])
    let rxHexConst = try! NSRegularExpression(pattern: "^((0(?![x|X]))|((0)([x|X])([0-9|A-F|a-f])+)|((0)([0-9]+)))", options: [.caseInsensitive])
    
    
    
    // Pre: sourceLine has one line of source code.
    // Post: If the next token is valid, the string of characters representing the next token are deleted from the
    // beginning of sourceLine and returned in tokenString, true is returned, and token is set to the token type.
    // Post: If false is returned, then tokenString is set to the lexical error message.
    func getToken(sourceLine: inout String, token: inout ELexicalToken, tokenString: inout String) -> Bool {
      
        sourceLine = sourceLine.trimmed()
        if sourceLine.length == 0 {
            token = ELexicalToken.lt_EMPTY
            tokenString = ""
            return true
        }
        let firstChar = sourceLine.first
        if firstChar == "," {
            token = ELexicalToken.lt_COMMA
            tokenString = ","
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if firstChar == "[" {
            token = ELexicalToken.lt_LEFT_BRACKET
            tokenString = "["
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if firstChar == "]" {
            token = ELexicalToken.lt_RIGHT_BRACKET
            tokenString = "]"
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if firstChar == "/" {
            
            if rxComment.index(ofAccessibilityElement: sourceLine) == -1 { //not sure this is it
                tokenString = "// ERROR: Malformed comment" // Should occur with single "/".
                return false
            }
            token = ELexicalToken.lt_COMMENT
            tokenString = rxComment.matchesIn(sourceLine)[0] // CHECK THIS ONE TOO
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if startsWithHexPrefix(str: sourceLine) {
            if (rxHexConst.index(ofAccessibilityElement: sourceLine) == -1) { /// here
                tokenString = "// ERROR: Malformed hex constant."
                return false
            }
            token = ELexicalToken.lt_HEX_CONSTANT
            tokenString = rxHexConst.matchesIn(sourceLine)[0] // here
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar?.isDigit())! {
            if rxDigit.index(ofAccessibilityElement: sourceLine) == -1 { ///here
                tokenString = "// ERROR: Malformed integer" // Should not occur.
                return false
            }
            token = ELexicalToken.lt_DIGIT;
            tokenString = rxDigit.matchesIn(sourceLine)[0] /// here
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if firstChar == "=" {
            token = ELexicalToken.lt_EQUALS
            tokenString = "="
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if (firstChar?.isLetter())! {
            if rxIdentifier.index(ofAccessibilityElement: sourceLine) == -1  { ///here
                tokenString = "// ERROR: Malformed identifier" // Should not occur
                return false
            }
            tokenString = rxIdentifier.matchesIn(sourceLine)[0] /// here
            token = tokenString[tokenString.endIndex] == ":" ? ELexicalToken.lt_PRE_POST : ELexicalToken.lt_IDENTIFIER /// here
            sourceLine.remove(0, tokenString.length)
            return true
        }
        if firstChar == ";" {
            token = ELexicalToken.lt_SEMICOLON;
            tokenString = ";"
            sourceLine.remove(0, tokenString.length)
            return true
        }
        tokenString = "// ERROR: Syntax error starting with " + String(firstChar!)
        return false
    }
    
    
    
    // Pre: sourceLine has one line of source code.
    // Pre: lineNum is the line number of the source code.
    // Post: If the source line is valid, true is returned and code is set to the source code for the line.
    // Post: If the source line is not valid, false is returned and errorString is set to the error message.
    // Checks for out of range integer values.
    // The only detected resource conflict checked is for duplicated fields.
    func processSourceLine(sourceLine: String, code: inout Code, errorString: inout String) -> Bool {
        //placeholder
        return false
    }
    
    func microAssemble() -> Bool {
        var sourceCode:String = cpuProjectModel.sourceStr
        print(sourceCode)
        return true
    }

func startsWithHexPrefix(str : String) -> Bool {
    if str.length < 2 {
        return false
    }
    if str[0] != "0"{
        return false
    }
    if str[1] == "x" || str[1] == "X"{
        return true
    }
    return false
}
    
}
