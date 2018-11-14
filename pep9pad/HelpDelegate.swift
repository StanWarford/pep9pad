//
//  HelpDelegate.swift
//  pep9pad
//
//  Created by David Nicholas on 11/14/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation

protocol HelpDelegate {
    
    var exampleVC : ExampleViewController! {get set}
    var documentationVC : DocumentationViewController! {get set}
    var helpDetail: HelpDetailController! {get set}
    
    func loadDocumentation(_ doc : Documentation)
    func loadExample(_ named : String) -> String // For Button Title
    
    func loadExampleToProj(_ text: String!, ofType: PepFileType!, io: String!, usesTerminal: Bool!)
}
