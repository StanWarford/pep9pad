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
        var token : ELexicalToken
        var tokenString : String // Passed to getToken.
        var localIdentifier  = "" // Saves identifier for processing in the following state.
        var localValue : Int
        var localAddressValue = 0 // = 0 to suppress compiler warning
        var localEnumMnemonic = CPUEMnemonic.LoadCk // Key to Pep:: table lookups. = Enu::LoadCk to suppress compiler warning
        var processingPrecondition = false // To distinguish between a precondition and a postcondition. = false to suppress compiler warning
        
        // The concrete code objects asssigned to code.
        var microCode : MicroCode?  = nil
        var commentOnlyCode : CommentOnlyCode? = nil
        var preconditionCode : UnitPreCode? = nil
        var postconditionCode : UnitPostCode? = nil
        var blankLineCode : BlankLineCode? = nil
        
        var state : ParseState = .ps_START
        repeat {
//            if !getToken(sourceLine: sourceLine, token: token, tokenString: tokenString){
//                errorString = tokenString
//                return false
//            }
        }
            while true
        
            //        qDebug() << "tokenString: " << tokenString;
//            switch (state) {
//            case ParseState.ps_START:
//                if token == ELexicalToken.lt_IDENTIFIER {
//                if (Pep::mnemonToDecControlMap.contains(tokenString.toUpper())) {
//                    microCode = new MicroCode();
//                    code = microCode;
//                    localEnumMnemonic = Pep::mnemonToDecControlMap.value(tokenString.toUpper());
//                    localIdentifier = tokenString;
//                    state = Asm::PS_EQUAL_DEC;
//                }
//                else if (Pep::mnemonToMemControlMap.contains(tokenString.toUpper())) {
//                    microCode = new MicroCode;
//                    code = microCode;
//                    localEnumMnemonic = Pep::mnemonToMemControlMap.value(tokenString.toUpper());
//                    microCode->set(localEnumMnemonic, 1);
//                    state = Asm::PS_CONTINUE_PRE_SEMICOLON;
//                }
//                else if (Pep::mnemonToClockControlMap.contains(tokenString.toUpper())) {
//                    errorString = "// ERROR: Clock signal " + tokenString + " must appear after semicolon";
//                    return false;
//                }
//                else {
//                    errorString = "// ERROR: Unrecognized control signal: " + tokenString;
//                    return false;
//                }
//            }
//            else if (token == Asm::LT_SEMICOLON) {
//                errorString = "// ERROR: No control signals before semicolon.";
//                return false;
//            }
//            else if (token == Asm::LT_COMMENT) {
//                commentOnlyCode = new CommentOnlyCode(tokenString);
//                code = commentOnlyCode;
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_PRE_POST) {
//                if (Pep::mnemonToSpecificationMap.contains(tokenString.toUpper())) {
//                    if (Pep::mnemonToSpecificationMap.value(tokenString.toUpper()) == Enu::Pre) {
//                        processingPrecondition = true;
//                        preconditionCode = new UnitPreCode();
//                        code = preconditionCode;
//                        state = PS_START_SPECIFICATION;
//                    }
//                    else { // E_Post
//                        processingPrecondition = false;
//                        postconditionCode = new UnitPostCode();
//                        code = postconditionCode;
//                        state = PS_START_SPECIFICATION;
//                    }
//                }
//                else {
//                    errorString = "// ERROR: Illegal specification symbol " + tokenString;
//                    return false;
//                }
//            }
//            else if (token == Asm::LT_EMPTY) {
//                blankLineCode = new BlankLineCode();
//                code = blankLineCode;
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Syntax error where control signal or comment expected";
//                return false;
//            }
//            break;
//
//            case Asm::PS_EQUAL_DEC:
//                if (token == Asm::LT_EQUALS) {
//                state = Asm::PS_DEC_CONTROL;
//            }
//            else {
//                errorString = "// ERROR: Expected = after " + localIdentifier;
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_DEC_CONTROL:
//                if (token == Asm::LT_DIGIT) {
//                if (microCode->has(localEnumMnemonic)) {
//                    errorString = "// ERROR: Duplicate control signal, " + localIdentifier;
//                    delete code;
//                    return false;
//                }
//                bool ok;
//                localValue = tokenString.toInt(&ok);
//                if (!microCode->inRange(localEnumMnemonic, localValue)) {
//                    errorString = "// ERROR: Value " + QString("%1").arg(localValue) + " is out of range for " + localIdentifier;
//                    delete code;
//                    return false;
//                }
//                microCode->set(localEnumMnemonic, localValue);
//                state = Asm::PS_CONTINUE_PRE_SEMICOLON;
//            }
//            else {
//                errorString = "// ERROR: Expected decimal number after " + localIdentifier + "=";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_CONTINUE_PRE_SEMICOLON:
//                if (token == Asm::LT_COMMA) {
//                state = Asm::PS_CONTINUE_PRE_SEMICOLON_POST_COMMA;
//            }
//            else if (token == Asm::LT_SEMICOLON) {
//                state = Asm::PS_START_POST_SEMICOLON;
//            }
//            else if (token == Asm::LT_COMMENT) {
//                microCode->cComment = tokenString;
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Expected ',' or ';' after control signal";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_CONTINUE_PRE_SEMICOLON_POST_COMMA:
//                if (token == Asm::LT_IDENTIFIER) {
//                if (Pep::mnemonToDecControlMap.contains(tokenString.toUpper())) {
//                    localEnumMnemonic = Pep::mnemonToDecControlMap.value(tokenString.toUpper());
//                    if (microCode->has(localEnumMnemonic)) {
//                        errorString = "// ERROR: Duplicate control signal, " + tokenString;
//                        delete code;
//                        return false;
//                    }
//                    localIdentifier = tokenString;
//                    state = Asm::PS_EQUAL_DEC;
//                }
//                else if (Pep::mnemonToMemControlMap.contains(tokenString.toUpper())) {
//                    localEnumMnemonic = Pep::mnemonToMemControlMap.value(tokenString.toUpper());
//                    if (microCode->has(localEnumMnemonic)) {
//                        errorString = "// ERROR: Duplicate control signal, " + tokenString;
//                        delete code;
//                        return false;
//                    }
//                    if (localEnumMnemonic == Enu::MemRead && microCode->has(Enu::MemWrite)) {
//                        errorString = "// ERROR: MemRead not allowed with MemWrite";
//                        delete code;
//                        return false;
//                    }
//                    if (localEnumMnemonic == Enu::MemWrite && microCode->has(Enu::MemRead)) {
//                        errorString = "// ERROR: MemWrite not allowed with MemRead";
//                        delete code;
//                        return false;
//                    }
//                    microCode->set(localEnumMnemonic, 1);
//                    state = Asm::PS_CONTINUE_PRE_SEMICOLON;
//                }
//                else if (Pep::mnemonToClockControlMap.contains(tokenString.toUpper())) {
//                    errorString = "// ERROR: Clock signal (" + tokenString + ") must appear after semicolon";
//                    delete code;
//                    return false;
//                }
//                else {
//                    errorString = "// ERROR: Unrecognized control signal: " + tokenString;
//                    delete code;
//                    return false;
//                }
//            }
//            else if (token == Asm::LT_SEMICOLON) {
//                errorString = "// ERROR: Control signal expected after comma.";
//                delete code;
//                return false;
//            }
//            else if (token == Asm::LT_COMMENT) {
//                microCode->cComment = tokenString;
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Syntax error where control signal or comment expected";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_START_POST_SEMICOLON:
//                if (token == Asm::LT_IDENTIFIER) {
//                if (Pep::mnemonToClockControlMap.contains(tokenString.toUpper())) {
//                    localEnumMnemonic = Pep::mnemonToClockControlMap.value(tokenString.toUpper());
//                    if (microCode->has(localEnumMnemonic)) {
//                        errorString = "// ERROR: Duplicate clock signal, " + tokenString;
//                        delete code;
//                        return false;
//                    }
//                    microCode->set(localEnumMnemonic, 1);
//                    state = Asm::PS_CONTINUE_POST_SEMICOLON;
//                }
//                else if (Pep::mnemonToDecControlMap.contains(tokenString.toUpper())) {
//                    errorString = "// ERROR: Control signal " + tokenString + " after ';'";
//                    delete code;
//                    return false;
//                }
//                else if (Pep::mnemonToMemControlMap.contains(tokenString.toUpper())) {
//                    errorString = "// ERROR: Memory control signal " + tokenString + " after ';'";
//                    delete code;
//                    return false;
//                }
//                else {
//                    errorString = "// ERROR: Unrecognized clock signal: " + tokenString;
//                    delete code;
//                    return false;
//                }
//            }
//            else if (token == Asm::LT_SEMICOLON) {
//                errorString = "// ERROR: Multiple semicolons.";
//                delete code;
//                return false;
//            }
//            else if (token == Asm::LT_COMMENT) {
//                microCode->cComment = tokenString;
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Syntax error where clock signal or comment expected.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_CONTINUE_POST_SEMICOLON:
//                if (token == Asm::LT_COMMA) {
//                state = Asm::PS_START_POST_SEMICOLON;
//            }
//            else if (token == Asm::LT_SEMICOLON) {
//                errorString = "// ERROR: Multiple semcolons ';'";
//                delete code;
//                return false;
//            }
//            else if (token == Asm::LT_COMMENT) {
//                microCode->cComment = tokenString;
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Expected ',' after clock signal";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_START_SPECIFICATION:
//                if (token == Asm::LT_IDENTIFIER) {
//                if (Pep::mnemonToMemSpecMap.contains(tokenString.toUpper())) {
//                    localEnumMnemonic = Pep::mnemonToMemSpecMap.value(tokenString.toUpper());
//                    state = Asm::PS_EXPECT_LEFT_BRACKET;
//                }
//                else if (Pep::mnemonToRegSpecMap.contains(tokenString.toUpper())) {
//                    localEnumMnemonic = Pep::mnemonToRegSpecMap.value(tokenString.toUpper());
//                    state = Asm::PS_EXPECT_REG_EQUALS;
//                }
//                else if (Pep::mnemonToStatusSpecMap.contains(tokenString.toUpper())) {
//                    localEnumMnemonic = Pep::mnemonToStatusSpecMap.value(tokenString.toUpper());
//                    state = Asm::PS_EXPECT_STATUS_EQUALS;
//                }
//                else {
//                    errorString = "// ERROR: Unrecognized specification symbol: " + tokenString;
//                    delete code;
//                    return false;
//                }
//            }
//            else if (token == Asm::LT_COMMENT) {
//                if (processingPrecondition) {
//                    preconditionCode->setComment(tokenString);
//                }
//                else {
//                    postconditionCode->setComment(tokenString);
//                }
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Syntax error starting with: " + tokenString;
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_LEFT_BRACKET:
//                if (token == Asm::LT_LEFT_BRACKET) {
//                state = Asm::PS_EXPECT_MEM_ADDRESS;
//            }
//            else {
//                errorString = "// ERROR: Expected [ after Mem.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_MEM_ADDRESS:
//                if (token == Asm::LT_HEX_CONSTANT) {
//                tokenString.remove(0, 2); // Remove "0x" prefix.
//                bool ok;
//                localAddressValue = tokenString.toInt(&ok, 16);
//                if (localAddressValue >= 65536) {
//                    errorString = "// ERROR: Hexidecimal address is out of range (0x0000..0xFFFF).";
//                    delete code;
//                    return false;
//                }
//                state = Asm::PS_EXPECT_RIGHT_BRACKET;
//            }
//            else {
//                errorString = "// ERROR: Expected hex memory address after [.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_RIGHT_BRACKET:
//                if (token == Asm::LT_RIGHT_BRACKET) {
//                state = Asm::PS_EXPECT_MEM_EQUALS;
//            }
//            else {
//                errorString = "// ERROR: Expected ] after memory address.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_MEM_EQUALS:
//                if (token == Asm::LT_EQUALS) {
//                state = Asm::PS_EXPECT_MEM_VALUE;
//            }
//            else {
//                errorString = "// ERROR: Expected = after ].";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_MEM_VALUE:
//                if (token == Asm::LT_HEX_CONSTANT) {
//                tokenString.remove(0, 2); // Remove "0x" prefix.
//                bool ok;
//                localValue = tokenString.toInt(&ok, 16);
//                if (localValue >= 65536) {
//                    errorString = "// ERROR: Hexidecimal memory value is out of range (0x0000..0xFFFF).";
//                    delete code;
//                    return false;
//                }
//                if (processingPrecondition) {
//                    preconditionCode->appendSpecification(new MemSpecification(localAddressValue, localValue, tokenString.length() > 2 ? 2 : 1));
//                }
//                else {
//                    postconditionCode->appendSpecification(new MemSpecification(localAddressValue, localValue, tokenString.length() > 2 ? 2 : 1));
//                }
//                state = Asm::PS_EXPECT_SPEC_COMMA;
//            }
//            else {
//                errorString = "// ERROR: Expected hex constant after =.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_REG_EQUALS:
//                if (token == Asm::LT_EQUALS) {
//                state = Asm::PS_EXPECT_REG_VALUE;
//            }
//            else {
//                errorString = "// ERROR: Expected = after " + Pep::regSpecToMnemonMap.value(localEnumMnemonic);
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_REG_VALUE:
//                if (token == Asm::LT_HEX_CONSTANT) {
//                tokenString.remove(0, 2); // Remove "0x" prefix.
//                bool ok;
//                localValue = tokenString.toInt(&ok, 16);
//                if (localEnumMnemonic == Enu::IR && localValue >= 16777216) {
//                    errorString = "// ERROR: Hexidecimal register value is out of range (0x000000..0xFFFFFF).";
//                    delete code;
//                    return false;
//                }
//                if (localEnumMnemonic == Enu::T1 && localValue >= 256) {
//                    errorString = "// ERROR: Hexidecimal register value is out of range (0x00..0xFF).";
//                    delete code;
//                    return false;
//                }
//                if (localEnumMnemonic != Enu::IR && localEnumMnemonic != Enu::T1 && localValue >= 65536) {
//                    errorString = "// ERROR: Hexidecimal register value is out of range (0x0000..0xFFFF).";
//                    delete code;
//                    return false;
//                }
//                if (processingPrecondition) {
//                    preconditionCode->appendSpecification(new RegSpecification(localEnumMnemonic, localValue));
//                }
//                else {
//                    postconditionCode->appendSpecification(new RegSpecification(localEnumMnemonic, localValue));
//                }
//                state = Asm::PS_EXPECT_SPEC_COMMA;
//            }
//            else {
//                errorString = "// ERROR: Expected hex constant after =.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_STATUS_EQUALS:
//                if (token == Asm::LT_EQUALS) {
//                state = Asm::PS_EXPECT_STATUS_VALUE;
//            }
//            else {
//                errorString = "// ERROR: Expected = after " + Pep::statusSpecToMnemonMap.value(localEnumMnemonic);
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_STATUS_VALUE:
//                if (token == Asm::LT_DIGIT) {
//                bool ok;
//                localValue = tokenString.toInt(&ok);
//                if (localValue > 1) {
//                    errorString = "// ERROR: Status bit value is out of range (0..1).";
//                    delete code;
//                    return false;
//                }
//                if (processingPrecondition) {
//                    preconditionCode->appendSpecification(new StatusBitSpecification(localEnumMnemonic, localValue == 1));
//                }
//                else {
//                    postconditionCode->appendSpecification(new StatusBitSpecification(localEnumMnemonic, localValue == 1));
//                }
//                state = Asm::PS_EXPECT_SPEC_COMMA;
//            }
//            else {
//                errorString = "// ERROR: Expected '1' or '0' after =.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_EXPECT_SPEC_COMMA:
//                if (token == Asm::LT_COMMA) {
//                state = Asm::PS_START_SPECIFICATION;
//            }
//            else if (token == Asm::LT_COMMENT) {
//                if (processingPrecondition) {
//                    preconditionCode->setComment(tokenString);
//                }
//                else {
//                    postconditionCode->setComment(tokenString);
//                }
//                state = Asm::PS_COMMENT;
//            }
//            else if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                errorString = "// ERROR: Expected ',' comment, or end of line.";
//                delete code;
//                return false;
//            }
//            break;
//
//            case Asm::PS_COMMENT:
//                if (token == Asm::LT_EMPTY) {
//                state = Asm::PS_FINISH;
//            }
//            else {
//                // This error should not occur, as all characters are allowed in comments.
//                errorString = "// ERROR: Problem detected after comment.";
//                delete code;
//                return false;
//            }
//            break;
//
//            default:
//                break;
//            }
//        }
//            while state != ParseState.ps_FINISH
//        return true
//        }
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
