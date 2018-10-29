//
//  ButtonStackView.swift
//  pep9pad
//
//  Created by David Nicholas on 10/29/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class ButtonStackView: UIStackView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let rect = CGRect(x: 0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1)
        let borderBottom = UIView(frame: rect)
        borderBottom.backgroundColor = UIColor.white
        
        let leftRect = CGRect(x: self.frame.size.width/3.0, y: 0, width: 1, height: self.frame.height)
        let leftBorder = UIView(frame: leftRect)
        leftBorder.backgroundColor = UIColor.white
        
        let rightRect = CGRect(x: 2.0 * (self.frame.size.width/3.0), y: 0, width: 1, height: self.frame.height)
        let rightBorder = UIView(frame: rightRect)
        rightBorder.backgroundColor = UIColor.white
        
        self.addSubview(leftBorder)
        self.addSubview(rightBorder)
        self.addSubview(borderBottom)
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, 1)];
//        lineView.backgroundColor = [UIColor redColor];
//        [btn addSubview:lineView];
//        you can do the same for each border. Adding multiple UIViews you can add bottom and left or top and right or any border you want.
//
//        i.e. bottom & left:
//
//        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - 1.0f, btn.frame.size.width, 1)];
//        bottomBorder.backgroundColor = [UIColor redColor];
//
//        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 1, btn.frame.size.height)];
//        leftBorder.backgroundColor = [UIColor redColor];
//
//        [btn addSubview:bottomBorder];
    }
 

}
