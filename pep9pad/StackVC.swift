//
//  StackVC.swift
//  pep9pad
//
//  Created by James Maynard on 6/14/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class StackVC: UIView {
    
    func drawBottomOfStack(_ rect: CGRect) {
        let x0 = rect.width/2.0 - 50.0
        let y0 = rect.height - 25.0

        let stagePath = UIBezierPath()
        stagePath.move(to: CGPoint(x: x0, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 121.98,y: y0))
        stagePath.move(to: CGPoint(x: x0 + 15.56, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 - 4.52, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 30.62, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 10.54, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 45.68, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 25.6, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 60.74, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 40.66, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 75.8, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 55.72, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 90.86, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 70.78, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 105.92, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 85.84, y: y0 + 15.0))
        stagePath.move(to: CGPoint(x: x0 + 120.98, y: y0))
        stagePath.addLine(to: CGPoint(x: x0 + 100.9, y: y0 + 15.0))
        UIColor.black.setStroke()
        stagePath.lineWidth = 2
        stagePath.stroke()
    }
    
    

}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

// MARK: JUNK
    
    // Put data structures from memorytracepane.h here from Pep9 desktop
    
    // Implement methods from memorytracepane.cpp here from Pep9 desktop

    
    
    

