//
//  ASMObjectCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_ObjectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)

    }
    
    
    // MARK: - Interface
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
}
