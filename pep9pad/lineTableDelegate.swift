//
//  lineTableDelegate.swift
//  pep9pad
//
//  Created by David Nicholas on 10/13/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation
import UIKit

protocol LineTableDelegate {
    func updateCPU(element : CPUEMnemonic, value : String)
    
    var copyMicroCodeLine : [CPUEMnemonic : Int] {get set}
}
