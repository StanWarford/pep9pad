//
//  CPUController.swift
//  pep9pad
//
//  Created by Josh Haug on 2/16/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

/// The global instance of the CPUController. Defaults to 1 byte.
var cpu: CPUController = CPU1ByteController()

/// Changes the bus instance 
func changeBusInstance(toSize: CPUBusSize) {
    if cpu.busSize != toSize {
        cpu = toSize == .oneByte ? CPU1ByteController() : CPU2ByteController()
    }
}

/// The abstract protocol to which both the CPU1ByteController and CPU2ByteController conform.
protocol CPUController {
    var busSize: CPUBusSize {get}
}
