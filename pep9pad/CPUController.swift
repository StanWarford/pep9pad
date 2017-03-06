//
//  CPUController.swift
//  pep9pad
//
//  Created by Josh Haug on 2/16/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

/// The global instance of the CPUController.
var cpuController: CPUController = CPUController()

class CPUController: UIViewController {
    
    // MARK: - Properties -
    /// The instance of the CPUXByteView.  Swapped out by `changeBusSize()`.
    var cpu: UIView = CPU1ByteView()
    /// The size of `cpu`'s bus.
    var currentBusSize: CPUBusSize = .oneByte
    
    // MARK: - Methods -
    
    func changeBusSize() {
        if currentBusSize == .oneByte {
            cpu = CPU2ByteView()
            currentBusSize = .twoByte
        } else {
            cpu = CPU1ByteView()
            currentBusSize = .oneByte
        }
    }
    
    // MARK: - View Controller Lifecycle -
    override func viewDidLoad() {
        self.view = cpu
        super.viewDidLoad()
    }
    
}
