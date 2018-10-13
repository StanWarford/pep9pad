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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lineName: UILabel!
    @IBAction func changeLineValue(_ sender: Any) {
        delegate.changeClockLine(line: line, value: true)
    }
    
    
}
