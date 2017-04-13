//
//  DebugMenuTraceTrapsCell.swift
//  pep9pad
//
//  Created by Josh Haug on 4/12/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class DebugMenuTraceTrapsCell: UITableViewCell {
    // MARK: IBActions
    
    @IBOutlet var traceTraps: UISwitch! {
        didSet {
            traceTraps.isOn = machine.tracingTraps
        }
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        machine.tracingTraps = traceTraps.isOn
    }
}
