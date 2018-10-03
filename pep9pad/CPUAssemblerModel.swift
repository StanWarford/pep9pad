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
            token = tokenString.last == ":" ? ELexicalToken.lt_PRE_POST : ELexicalToken.lt_IDENTIFIER /// here
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
    func processSourceLine(sourceLine: inout String, code: inout CPUCode, errorString: inout String) -> Bool {
        var token = ELexicalToken.lt_COMMA // initialized just to be able to pass it
        var tokenString = "" // Passed to getToken.
        var localIdentifier  = "" // Saves identifier for processing in the following state.
        var localValue : Int
        var localAddressValue = 0 // = 0 to suppress compiler warning
        var localEnumMnemonic = CPUEMnemonic.LoadCk // Key to Pep:: table lookups. = Enu::LoadCk to suppress compiler warning
        var processingPrecondition = false // To distinguish between a precondition and a postcondition. = false to suppress compiler warning
        
        // The concrete code objects asssigned to code.
        
        // IS THERE A WAY AROUND THIS ERROR
        var microCode : MicroCode = MicroCode()
        var commentOnlyCode : CommentOnlyCode = CommentOnlyCode(comment: "")
        var preconditionCode : UnitPreCode = UnitPreCode()
        var postconditionCode : UnitPostCode = UnitPostCode()
        var blankLineCode : BlankLineCode = BlankLineCode()
        
        var state : ParseState = .ps_START
    
        initEnumMnemonMaps() // might not need this
        repeat {
            if !getToken(sourceLine: &sourceLine, token: &token, tokenString: &tokenString){
                errorString = tokenString
                return false
            }
        
                    //qDebug() << "tokenString: " << tokenString;
            switch (state) {
            case ParseState.ps_START:
                if token == ELexicalToken.lt_IDENTIFIER {
                    if mnemonToDecControlMap.keys.contains(tokenString.uppercased()) {
                        microCode = MicroCode()
                        code = microCode
                        localEnumMnemonic = mnemonToDecControlMap[tokenString.uppercased()]!
                        localIdentifier = tokenString
                        state = .ps_EQUAL_DEC
                    }
                    else if mnemonToMemControlMap.keys.contains(tokenString.uppercased()) {
                        microCode = MicroCode()
                        code = microCode
                        localEnumMnemonic = mnemonToMemControlMap[tokenString.uppercased()]!
                        microCode.set(field: localEnumMnemonic, value: 1)
                        state = .ps_CONTINUE_PRE_SEMICOLON
                    }
                    else if mnemonToClockControlMap.keys.contains(tokenString.uppercased()){
                        errorString = "// ERROR: Clock signal " + tokenString + " must appear after semicolon"
                        return false
                    }
                    else {
                        errorString = "// ERROR: Unrecognized control signal: " + tokenString
                        return false
                    }
                }
                else if token == .lt_SEMICOLON {
                    errorString = "// ERROR: No control signals before semicolon."
                    return false
                }
                else if token == .lt_COMMENT {
                    commentOnlyCode = CommentOnlyCode(comment: tokenString)
                    code = commentOnlyCode
                    state = .ps_COMMENT
                }
                else if (token == .lt_PRE_POST) {
                    if mnemonToSpecificationMap.keys.contains(tokenString.uppercased()){
                        if mnemonToSpecificationMap[tokenString.uppercased()] == .Pre {
                            processingPrecondition = true
                            preconditionCode = UnitPreCode()
                            code = preconditionCode
                            state = .ps_START_SPECIFICATION
                        }
                        else { // E_Post
                            processingPrecondition = false
                            postconditionCode = UnitPostCode()
                            code = postconditionCode
                            state = .ps_START_SPECIFICATION
                        }
                    }
                    else {
                        errorString = "// ERROR: Illegal specification symbol " + tokenString
                        return false
                    }
                }
                else if token == .lt_EMPTY {
                    blankLineCode = BlankLineCode()
                    code = blankLineCode
                    state = .ps_FINISH
                }
                else {
                    errorString = "// ERROR: Syntax error where control signal or comment expected"
                    return false
                }
                
            case .ps_EQUAL_DEC:
                if token == .lt_EQUALS {
                state = .ps_DEC_CONTROL
            }else {
                errorString = "// ERROR: Expected = after " + localIdentifier
                return false
            }
                
            case .ps_DEC_CONTROL:
                if token == .lt_DIGIT {
                    if microCode.has(field: localEnumMnemonic) {
                    errorString = "// ERROR: Duplicate control signal, " + localIdentifier
                    return false
                }
                    localValue = Int(tokenString)!
                    if !microCode.inRange(field: localEnumMnemonic, value: localValue){
                    errorString = "// ERROR: Value " + String(localValue) + " is out of range for " + localIdentifier
                    return false
                }
                    microCode.set(field: localEnumMnemonic, value: localValue)
                state = .ps_CONTINUE_PRE_SEMICOLON
                }
                else {
                    errorString = "// ERROR: Expected decimal number after " + localIdentifier + "="
                    return false
                    }
                case .ps_CONTINUE_PRE_SEMICOLON:
                    if token == .lt_COMMA {
                        state = .ps_CONTINUE_PRE_SEMICOLON_POST_COMMA
                    }
                else if token == .lt_SEMICOLON {
                        state = .ps_START_POST_SEMICOLON
                    }
                else if token == .lt_COMMENT{
                        microCode.cComment = tokenString
                        state = .ps_COMMENT
                    }
                else if token == .lt_EMPTY {
                        state = .ps_FINISH
                    }
                else {
                        errorString = "// ERROR: Expected ',' or ';' after control signal"
                        return false
                    }
                
            case .ps_CONTINUE_PRE_SEMICOLON_POST_COMMA:
                if token == .lt_IDENTIFIER {
                if mnemonToDecControlMap.keys.contains(tokenString.uppercased()){
                    localEnumMnemonic = mnemonToDecControlMap[tokenString.uppercased()]!
                    if microCode.has(field: localEnumMnemonic){
                        errorString = "// ERROR: Duplicate control signal, " + tokenString
                        return false
                    }
                    localIdentifier = tokenString
                    state = .ps_EQUAL_DEC
                }
                else if mnemonToMemControlMap.keys.contains(tokenString.uppercased()){
                    localEnumMnemonic = mnemonToMemControlMap[tokenString.uppercased()]!
                    if microCode.has(field: localEnumMnemonic) {
                        errorString = "// ERROR: Duplicate control signal, " + tokenString
                        return false
                    }
                    if localEnumMnemonic == .MemRead && microCode.has(field: .MemWrite) {
                        errorString = "// ERROR: MemRead not allowed with MemWrite"
                        return false
                    }
                    if localEnumMnemonic == .MemWrite && microCode.has(field: .MemRead) {
                        errorString = "// ERROR: MemWrite not allowed with MemRead"
                        return false
                    }
                    microCode.set(field: localEnumMnemonic, value: 1)
                    state = .ps_CONTINUE_PRE_SEMICOLON
                }
                else if mnemonToClockControlMap.keys.contains(tokenString.uppercased()) {
                    errorString = "// ERROR: Clock signal (" + tokenString + ") must appear after semicolon"
                    return false
                }
                else {
                    errorString = "// ERROR: Unrecognized control signal: " + tokenString
                    return false
                }
                }
                else if token == .lt_SEMICOLON {
                    errorString = "// ERROR: Control signal expected after comma."
                    return false
                }
                else if token == .lt_COMMENT {
                    microCode.cComment = tokenString
                    state = .ps_COMMENT
                }
                else if token == .lt_EMPTY {
                    state = .ps_FINISH
                }
                else {
                    errorString = "// ERROR: Syntax error where control signal or comment expected"
                    return false
                }
                
            case .ps_START_POST_SEMICOLON:
                if token == .lt_IDENTIFIER {
                        if mnemonToClockControlMap.keys.contains(tokenString.uppercased()) {
                            localEnumMnemonic = mnemonToClockControlMap[tokenString.uppercased()]!
                            if microCode.has(field: localEnumMnemonic) {
                                errorString = "// ERROR: Duplicate clock signal, " + tokenString
                                return false
                            }
                            microCode.set(field: localEnumMnemonic, value: 1)
                            state = .ps_CONTINUE_POST_SEMICOLON
                    }
                    else if mnemonToDecControlMap.keys.contains(tokenString.uppercased()){
                        errorString = "// ERROR: Control signal " + tokenString + " after ';'"
                        return false
                    }
                    else if mnemonToMemControlMap.keys.contains(tokenString.uppercased()) {
                        errorString = "// ERROR: Memory control signal " + tokenString + " after ';'"
                        return false
                    }
                    else {
                        errorString = "// ERROR: Unrecognized clock signal: " + tokenString
                        return false
                    }
                }
                else if token == .lt_SEMICOLON {
                    errorString = "// ERROR: Multiple semicolons."
                    return false
                }
                else if token == .lt_COMMENT {
                    microCode.cComment = tokenString
                    state = .ps_COMMENT
                }
                else if token == .lt_EMPTY {
                    state = .ps_FINISH
                }
                else {
                    errorString = "// ERROR: Syntax error where clock signal or comment expected."
                    return false
                }
                
            case .ps_CONTINUE_POST_SEMICOLON:
                if token == .lt_COMMA {
                state = .ps_START_POST_SEMICOLON
                }
                else if token == .lt_SEMICOLON {
                    errorString = "// ERROR: Multiple semcolons ';'"
                    return false
                }
                else if token == .lt_COMMENT {
                    microCode.cComment = tokenString
                    state = .ps_COMMENT
                }
                else if token == .lt_EMPTY {
                    state = .ps_FINISH
                }
                else {
                    errorString = "// ERROR: Expected ',' after clock signal"
                    return false
                }
            case.ps_START_SPECIFICATION:
                if token == .lt_IDENTIFIER {
                    if mnemonToMemSpecMap.keys.contains(tokenString.uppercased()) {
                        localEnumMnemonic = mnemonToMemSpecMap[tokenString.uppercased()]!
                        state = .ps_EXPECT_LEFT_BRACKET
                    }
                    else if mnemonToRegSpecMap.keys.contains(tokenString.uppercased()) {
                        localEnumMnemonic = mnemonToRegSpecMap[tokenString.uppercased()]!
                        state = .ps_EXPECT_REG_EQUALS
                    }
                    else if mnemonToStatusSpecMap.keys.contains(tokenString.uppercased()) {
                        localEnumMnemonic = mnemonToStatusSpecMap[tokenString.uppercased()]!
                        state = .ps_EXPECT_STATUS_EQUALS;
                    }
                    else {
                        errorString = "// ERROR: Unrecognized specification symbol: " + tokenString
                        return false
                    }
                }
                else if token == .lt_COMMENT {
                    if processingPrecondition {
                        preconditionCode.setComment(comment: tokenString)
                    }
                    else {
                        postconditionCode.setComment(comment: tokenString)
                    }
                    state = .ps_COMMENT
                }
                else if (token == .lt_EMPTY) {
                    state = .ps_FINISH
                }
                else {
                    errorString = "// ERROR: Syntax error starting with: " + tokenString
                    return false
                }
            case .ps_EXPECT_LEFT_BRACKET:
                if token == .lt_LEFT_BRACKET {
                    state = .ps_EXPECT_MEM_ADDRESS
                }
                else {
                    errorString = "// ERROR: Expected [ after Mem."
                    return false
                }
                
            case .ps_EXPECT_MEM_ADDRESS:
                if token == .lt_HEX_CONSTANT {
                    tokenString.remove(0, 2) // Remove "0x" prefix.
                    localAddressValue = tokenString.toInt(value: 16) // CHECK THIS
                    if localAddressValue >= 65536 {
                            errorString = "// ERROR: Hexidecimal address is out of range (0x0000..0xFFFF)."
                            return false
                    }
                    state = .ps_EXPECT_RIGHT_BRACKET
                }
                else {
                    errorString = "// ERROR: Expected hex memory address after [."
                    return false
                }
                
            case .ps_EXPECT_RIGHT_BRACKET:
                if token == .lt_RIGHT_BRACKET {
                state = .ps_EXPECT_MEM_EQUALS
                }
                else {
                    errorString = "// ERROR: Expected ] after memory address."
                    return false
                }
                
            case .ps_EXPECT_MEM_EQUALS:
                if token == .lt_EQUALS {
                    state = .ps_EXPECT_MEM_VALUE
                }
                else {
                    errorString = "// ERROR: Expected = after ]."
                    return false
                }
                
            case .ps_EXPECT_MEM_VALUE:
                if token == .lt_HEX_CONSTANT {
                tokenString.remove(0, 2) // Remove "0x" prefix.
                    localValue = tokenString.toInt(value: 16) // CHECK THIS
                if localValue >= 65536 {
                        errorString = "// ERROR: Hexidecimal memory value is out of range (0x0000..0xFFFF)."
                        return false
                }
                if processingPrecondition {
                    preconditionCode.appendSpecification(specification: MemSpecification(memoryAddress: localAddressValue, memoryValue: localValue, numberBytes: tokenString.length > 2 ? 2 : 1))
                }
                else {
                    postconditionCode.appendSpecification(specification: MemSpecification(memoryAddress: localAddressValue, memoryValue: localValue, numberBytes: tokenString.length > 2 ? 2 : 1))
                }
                state = .ps_EXPECT_SPEC_COMMA
                }
                else {
                    errorString = "// ERROR: Expected hex constant after =."
                    return false
                }
                
            case .ps_EXPECT_REG_EQUALS:
                    if token == .lt_EQUALS {
                        state = .ps_EXPECT_REG_VALUE
                    }
                    else {
                        errorString = "// ERROR: Expected = after " + regSpecToMnemonMap[localEnumMnemonic]!
                        return false
                    }
                
            case .ps_EXPECT_REG_VALUE:
                if token == .lt_HEX_CONSTANT {
                    tokenString.remove(0, 2) // Remove "0x" prefix.
                    localValue = tokenString.toInt(value: 16)
                    if localEnumMnemonic == .IR && localValue >= 16777216 {
                        errorString = "// ERROR: Hexidecimal register value is out of range (0x000000..0xFFFFFF)."
                        return false
                    }
                    if localEnumMnemonic == .T1 && localValue >= 256 {
                        errorString = "// ERROR: Hexidecimal register value is out of range (0x00..0xFF)."
                        return false
                    }
                    if localEnumMnemonic != .IR && localEnumMnemonic != .T1 && localValue >= 65536 {
                        errorString = "// ERROR: Hexidecimal register value is out of range (0x0000..0xFFFF)."
                        return false
                    }
                    if processingPrecondition {
                        preconditionCode.appendSpecification(specification: RegSpecification(registerAddress: localEnumMnemonic, registerValue: localValue))
                    }
                    else {
                        postconditionCode.appendSpecification(specification: RegSpecification(registerAddress: localEnumMnemonic, registerValue: localValue))
                    }
                state = .ps_EXPECT_SPEC_COMMA
                }
                else {
                    errorString = "// ERROR: Expected hex constant after =."
                    return false
                }
                
            case .ps_EXPECT_STATUS_EQUALS:
                if token == .lt_EQUALS {
                state = .ps_EXPECT_STATUS_VALUE
                }
                else {
                    errorString = "// ERROR: Expected = after " + statusSpecToMnemonMap[localEnumMnemonic]!
                    return false
                }
                
            case .ps_EXPECT_STATUS_VALUE:
                if token == .lt_DIGIT {
                        localValue = Int(tokenString)!
                    if (localValue > 1) {
                        errorString = "// ERROR: Status bit value is out of range (0..1)."
                        return false
                    }
                    if processingPrecondition {
                        preconditionCode.appendSpecification(specification: StatusBitSpecification(statusBitAddress: localEnumMnemonic, statusBitValue: localValue == 1))
                    }
                    else {
                        postconditionCode.appendSpecification(specification: StatusBitSpecification(statusBitAddress: localEnumMnemonic, statusBitValue: localValue == 1))
                    }
                    state = .ps_EXPECT_SPEC_COMMA
                }
                else {
                    errorString = "// ERROR: Expected '1' or '0' after =."
                    return false
                }
                
            case .ps_EXPECT_SPEC_COMMA:
                if token == .lt_COMMA {
                state = .ps_START_SPECIFICATION
                }
                else if token == .lt_COMMENT {
                    if processingPrecondition {
                        preconditionCode.setComment(comment: tokenString)
                    }
                    else {
                        postconditionCode.setComment(comment: tokenString)
                    }
                    state = .ps_COMMENT
                }
                else if token == .lt_EMPTY {
                    state = .ps_FINISH
                }
                else {
                    errorString = "// ERROR: Expected ',' comment, or end of line."
                    return false
                }
                
            case .ps_COMMENT:
                if token == .lt_EMPTY {
                state = .ps_FINISH
                }
                else {
                    // This error should not occur, as all characters are allowed in comments.
                    errorString = "// ERROR: Problem detected after comment."
                    return false
                }
                
            default:
                break;
                
            }
        } while state != ParseState.ps_FINISH
        return true
    }
    
    func microAssemble() -> Bool {
//        var sourceCode:String = cpuProjectModel.sourceStr
//        print(sourceCode)
//        return true
        
        var sourceLine : String
        var errorString : String = ""
        
        var code : CPUCode = MicroCode() //Initialized to pass
        var lineNum = 0
//        removeErrorMessages();
//        Sim::codeList.clear();
        
        let sourceCode = cpuProjectModel.sourceStr
        var sourceCodeList = sourceCode.split(separator: "\n")
        
        while lineNum < sourceCodeList.count {
            sourceLine = String(sourceCodeList[lineNum])
            if !processSourceLine(sourceLine: &sourceLine, code: &code, errorString: &errorString) {
                //appendMessageInSourceCodePaneAt(lineNum, errorString)
                print("assemble failed")
                return false
            }
//            Sim::codeList.append(code);
//            if (code->isMicrocode()) {
//                Sim::cycleCount++;
//            }
            lineNum = lineNum + 1
        }
//        // we guarantee a \n at the end of our document for single step highlighting
//        if (!sourceCode.endsWith("\n")) {
//            editor->appendPlainText("\n");
//        }
        print("Asseble Success")
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
