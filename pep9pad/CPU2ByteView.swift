//
//  CPU2ByteView.swift
//  pep9pad
//
//  Created by Stan Warford on 2/15/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
@IBDesignable
class CPU2ByteView: UIView {
    override func draw(_ rect: CGRect) {
        CPU2ByteRenderer.drawPep9CPUIPad97()
    }
}
