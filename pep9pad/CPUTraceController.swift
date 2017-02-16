//
//  CPUTraceController.swift
//  pep9pad
//
//  Created by Stan Warford on 2/8/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
class CPUTraceController: UIViewController {
    
    // MARK: - ViewController Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods -
    /// Updates this VC to be consistent with the bus size in the cpuProjectModel.
    func busSizeChanged() {
        print("trace controller will update accordingly")
    }
}
