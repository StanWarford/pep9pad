//
//  HelpDoubleTextViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/15/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class DoubleTextViewController: UIViewController {
    
    @IBOutlet weak var topTextView: PepTextView!
    @IBOutlet weak var bottomTextView: PepTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextView.setupTextView(topTextView.bounds)
        bottomTextView.setupTextView(bottomTextView.bounds)
    }
}
