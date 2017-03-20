//
//  FontMenuSizeCell.swift
//  pep9pad
//
//  Created by Josh Haug on 3/3/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class FontMenuSizeCell: UITableViewCell {
    // MARK: IBActions
    
    @IBOutlet var stepper: UIStepper! {
        didSet {
            stepper.value = Double(appSettings.fontSize)
        }
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        appSettings.fontSize = CGFloat(stepper.value)
        appSettings.saveSettings()
    }
}
