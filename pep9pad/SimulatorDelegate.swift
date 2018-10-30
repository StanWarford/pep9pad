//
//  SimulatorDelegate.swift
//  pep9pad
//
//  Created by David Nicholas on 10/29/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation

protocol SimulatorDelegate {
    var codeList : [CPUCode]! {get set}
    var cycleCount : Int! {get set}
}
