//
//  FontMenuColorCell.swift
//  pep9pad
//
//  Created by Josh Haug on 3/3/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class FontMenuColorCell: UITableViewCell {
    // MARK: Interface Builder Outlets and Actions

    
    @IBOutlet var lightColorBtn: UIButton! {
        didSet {
            lightColorBtn.layer.borderWidth = 2.0
            lightColorBtn.layer.borderColor = appSettings.darkModeOn ? UIColor.clear.cgColor : UIColor.blue.cgColor
            
        }
    }
    
    @IBOutlet var darkColorBtn: UIButton! {
        didSet {
            darkColorBtn.layer.borderWidth = 2.0
            darkColorBtn.layer.borderColor = appSettings.darkModeOn ? UIColor.blue.cgColor : UIColor.clear.cgColor
        }
    }

    
    
    @IBAction func lightColorBtnPressed(_ sender: UIButton) {
        appSettings.darkModeOn = false
        appSettings.saveSettings()
        drawOutline(forBtn: lightColorBtn, selected: true)
        drawOutline(forBtn: darkColorBtn, selected: false)
    }
    
    @IBAction func darkColorBtnPressed(_ sender: UIButton) {
        appSettings.darkModeOn = true
        appSettings.saveSettings()
        drawOutline(forBtn: lightColorBtn, selected: false)
        drawOutline(forBtn: darkColorBtn, selected: true)
    }
    
    func drawOutline(forBtn b: UIButton, selected: Bool) {
        b.layer.borderWidth = 2.0
        b.layer.borderColor = selected ? UIColor.blue.cgColor : UIColor.clear.cgColor
    }
    
    
}
