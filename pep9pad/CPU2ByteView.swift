//
//  CPU2ByteView.swift
//  pep9pad
//
//  Created by Josh Haug on 2/20/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

@IBDesignable
class CPU2ByteView: CPUView {
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.busSize = .twoByte
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.busSize = .twoByte
    }
    
    
    // MARK: - Drawing -
    override func draw(_ rect: CGRect) {
        // Need to do this, otherwise the background will default to black.
        UIColor.white.setFill()
        UIRectFill(rect)
        // Now draw from renderer.
        CPU2ByteRenderer.drawIpad()
    }
}
