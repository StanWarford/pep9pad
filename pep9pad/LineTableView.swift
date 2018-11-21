//
//  LineTableView.swift
//  pep9pad
//
//  Created by David Nicholas on 10/13/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class LineTableView: UIView {

    var masterVC : CPUViewController!
    
    @IBAction func copyToMicroCode(_ sender: UIButton) {
        masterVC.copyToMicroCode()
    }
    
}
