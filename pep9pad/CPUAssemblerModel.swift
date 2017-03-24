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
        //placeholder
        return false
    }
    
    
    
    // Pre: sourceLine has one line of source code.
    // Pre: lineNum is the line number of the source code.
    // Post: If the source line is valid, true is returned and code is set to the source code for the line.
    // Post: If the source line is not valid, false is returned and errorString is set to the error message.
    // Checks for out of range integer values.
    // The only detected resource conflict checked is for duplicated fields.
    func processSourceLine(sourceLine: String, cpuCode: inout CPUCode, errorString: inout String) -> Bool {
        //placeholder
        return false
    }
    
    func microAssemble() -> Bool {
        var sourceCode: String = cpuProjectModel.sourceStr
        print(sourceCode)
        
        var sourceLine: String
        var errorString: String = ""
        // QStringList sourceCodeList;
        var cpuCode: CPUCode = CPUCode()
        var lineNum: Int = 0
        // removeErrorMessages();
        var cpuCodeList = [CPUCode]()
        // Sim::codeList.clear();
        // QString sourceCode = editor->toPlainText();
        // sourceCodeList = sourceCode.split('\n');
        let sourceCodeList = sourceCode.components(separatedBy: "\n")
        for (lineNum, sourceLine) in sourceCodeList.enumerated() {
            print("\(lineNum): " + sourceLine)
            if (!processSourceLine(sourceLine: sourceLine, cpuCode: &cpuCode, errorString: &errorString)) {
                //appendMessageInSourceCodePaneAt(lineNum, errorString);
                return false
            }
            cpuCodeList.append(cpuCode)
        }
        
        // while (lineNum < sourceCodeList.size()) {
        //     sourceLine = sourceCodeList[lineNum];
        //     if (!Asm::processSourceLine(sourceLine, code, errorString)) {
        //         appendMessageInSourceCodePaneAt(lineNum, errorString);
        //         return false;
        //     }
        //     Sim::codeList.append(code);
        //     if (code->isMicrocode()) {
        //         Sim::cycleCount++;
        //     }
        //     lineNum++;
        // }
        // we guarantee a \n at the end of our document for single step highlighting
        // if (!sourceCode.endsWith("\n")) {
        //     editor->appendPlainText("\n");
        // }
        
        return true
    }
    
}
