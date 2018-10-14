//
//  numericLineCell.swift
//  pep9pad
//
//  Created by David Nicholas on 10/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

@IBDesignable
class numericLineCell: UITableViewCell {
    var line : CPUEMnemonic!
    var delegate : LineTableDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var textField: UITextField! {
        didSet {
            
        }
    }
    @IBAction func editLineValue(_ sender: Any) {
        
        delegate.copyMicroCodeLine[line] = Int(textField.text!)
        delegate.updateCPU(element: line, value: textField.text!)
    
    }
    @IBAction func changeLineValue(_ sender: Any) {
        
    }
    @IBOutlet weak var lineName: UILabel!
    
}
