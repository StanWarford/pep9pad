//
//  CPUController.swift
//  pep9pad
//
//  Created by Josh Haug on 2/16/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

/// The global instance of the CPUView. Defaults to 1 byte.
var cpuView: CPUView = CPU1ByteView(frame: CGRect(x: 0, y: 0, width: 750, height: 750))

/// Changes the bus instance 
func changeBusInstance(toSize: CPUBusSize) {
    if cpuView.busSize != toSize {
        cpuView = (toSize == .oneByte) ? CPU1ByteView() : CPU2ByteView()
    }
}

/// The abstract class to which both the CPU1ByteController and CPU2ByteController conform.
class CPUView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var busSize: CPUBusSize = .oneByte // defaults to oneByte for simplicity
}
