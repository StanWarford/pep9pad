//
//  StackCell.swift
//  pep9pad
//
//  Created by Josh Haug on 8/12/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class StackCell: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBOutlet var value: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
