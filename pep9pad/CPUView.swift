//
//  TestView.swift
//  pep9pad
//
//  Created by Stan Warford on 2/20/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
@IBDesignable
class CPUView: UIView {
    override func draw(_ rect: CGRect) {
        CPURenderer.drawPep9CPUIPad97()
    }
}
