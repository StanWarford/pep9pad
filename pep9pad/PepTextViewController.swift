//
//  PepTextViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/14/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class PepTextViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.font = UIFont(name: InconsolataRegular, size: 16)
        textView.directionalLockEnabled = true
        textView.textAlignment = .Left
    }
    
    
    @IBOutlet weak var textView: UITextView!
    
    
    
    
    
    
    
    
    
    
    
    
}
