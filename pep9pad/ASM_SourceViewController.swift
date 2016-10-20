//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/12/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_SourceViewController: UIViewController {
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        textView.loadExample("myFirstProgram", ofType: .pep)
    }
    
    
    
    // MARK: - IBOutlets
    
    
    //@IBOutlet var textView: PepTextView!
    

    
}
