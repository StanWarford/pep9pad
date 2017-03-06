//
//  CPU1ByteView
//  pep9pad
//
//  Created by Stan Warford on 2/20/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
@IBDesignable
class CPU1ByteView: UIView {
    override func draw(_ rect: CGRect) {
        CPU1ByteRenderer.drawPep9CPUIPad97()
    }
}
