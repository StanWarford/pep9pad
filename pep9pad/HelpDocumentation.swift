//
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

enum Documentation : String {
    case AssemblyLanguage = "assemblylanguage"
    case DebuggingPrograms = "debuggingprograms"
    //case Examples = "examples"
    case MachineLanguage = "machinelanguage"
    case Reference = "pep9reference"
    //case Problems = "problems"
    case WritingPrograms = "writingprograms"
    case WritingTrapHandlers = "writingtraphandlers"
    case InteractiveUse = "cpu"
    
    //cpu
    case UsingCPU = "usingpep9cpu"
    case DebuggingUse = "debugging"
    case MicrocodeUse = "beta"
    
    static let allASM : [Documentation : String] = [
        WritingPrograms: "Writing Programs",
        MachineLanguage: "Machine Language",
        AssemblyLanguage: "Assembly Language",
        DebuggingPrograms: "Debugging Programs",
        WritingTrapHandlers: "Writing Trap Handlers",
        Reference: "Pep/9 Reference",
    ]
    
    static let allCPU : [Documentation : String] = [
        UsingCPU: "Using Pep/9 CPU",
        InteractiveUse: "Interactive Use",
        DebuggingUse: "Debugging Use",
        MicrocodeUse: "Microcode Use",
         Reference: "Pep/9 Reference"
    ]
    
    static let allValues: [Documentation:String] = [
        WritingPrograms: "Writing Programs",
        MachineLanguage: "Machine Language",
        AssemblyLanguage: "Assembly Language",
        DebuggingPrograms: "Debugging Programs",
        WritingTrapHandlers: "Writing Trap Handlers",
        Reference: "Pep/9 Reference",
        UsingCPU: "Using Pep/9 CPU",
        InteractiveUse: "Interactive Use",
        DebuggingUse: "Debugging Use",
        MicrocodeUse: "Microcode Use"
    ]
}
