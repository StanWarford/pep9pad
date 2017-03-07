//
//  pep9pad
//
//  Created by Josh Haug on 2/28/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
import CoreGraphics

class MemoryCellGraphicsItem: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        //let r = CGRect(x: 30, y: 30, width: 75, height: 35)
        let clipPath: CGPath = UIBezierPath(rect: rect) as! CGPath
        //let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0) as! CGPath
        
        
        ctx.addPath(clipPath)
        ctx.setFillColor(UIColor.red.cgColor)
        
        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
        
    }
}
