//
//  HelpDoubleTextViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/15/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class DoubleTextViewController: UIViewController {
    
    @IBOutlet weak var leftTextView: PepTextView!
    @IBOutlet weak var rightTextView: PepTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTextView.setupTextView()
        rightTextView.setupTextView()
    }
}
