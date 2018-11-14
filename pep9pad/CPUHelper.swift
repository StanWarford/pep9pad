//
//  CPUHelper.swift
//  pep9pad
//
//  Created by David Nicholas on 11/14/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation
import UIKit

class CPUHelper : NSObject, HelpDelegate, UITableViewDelegate {
    var exampleVC: ExampleViewController!
    
    var documentationVC: DocumentationViewController!
    
    var helpDetail: HelpDetailController!
    
    func loadDocumentation(_ doc: Documentation) {
        print("load Doc")
    }
    
    func loadExample(_ named: String) -> String {
        return ""
    }
    
    func loadExampleToProj(_ text: String!, ofType: PepFileType!, io: String!, usesTerminal: Bool!) {
        print("load EX to Proj")
    }
    
   
    
    
}
