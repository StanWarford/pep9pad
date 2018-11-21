//
//  buttonStackViewBottom.swift
//  pep9pad
//
//  Created by David Nicholas on 10/29/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class buttonStackViewBottom: UIStackView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let leftRect = CGRect(x: self.frame.size.width/3.0, y: 0, width: 1, height: self.frame.height)
        let leftBorder = UIView(frame: leftRect)
        leftBorder.backgroundColor = UIColor.white
        
        let rightRect = CGRect(x: 2.0 * (self.frame.size.width/3.0), y: 0, width: 1, height: self.frame.height)
        let rightBorder = UIView(frame: rightRect)
        rightBorder.backgroundColor = UIColor.white
        
        self.addSubview(leftBorder)
        self.addSubview(rightBorder)
    }
 

}
