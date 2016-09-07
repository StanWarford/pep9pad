//
//  CPUCell.swift
//  pep9pad
//
//  Created by Josh Haug on 7/6/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class CPUCell: UIView {
    
// MARK: - Overriden Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// The name of the register.
    @IBOutlet weak var nameLabel: UILabel!
    
    /// The left textfield. In most cases (except for the Instruction Specifier cell) this holds the **hexadecimal representation** of the register.
    @IBOutlet weak var leftField: UITextField!
    
    /// The right textfield. In most cases (except for the Instruction Specifier cell) this holds the **decimal representation** of the register.
    @IBOutlet weak var rightField: UITextField!

}
