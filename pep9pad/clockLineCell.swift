//
//  clockLineCell.swift
//  pep9pad
//
//  Created by David Nicholas on 10/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

@IBDesignable
class clockLineCell: UITableViewCell {
    var line : CPUEMnemonic!
    var delegate : LineTableDelegate!
    var lineActive = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lineName: UILabel!
    @IBOutlet weak var checkbox: UIButton!{
        didSet{
            checkbox.layer.borderWidth = 0.5
            checkbox.layer.cornerRadius = 5
            checkbox.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func changeLineValue(_ sender: Any) {
        lineActive = !lineActive
        let buttonTitle = lineActive ? "✓" : ""
        checkbox.setTitle(buttonTitle, for: .normal)
        delegate.updateCPU(element: line, value: buttonTitle)
    }
    
    
}
