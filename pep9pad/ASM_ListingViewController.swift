//
//  ASM_ListingViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/20/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_ListingViewController: UIViewController, ASM_ProjectModelEditor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        textView.setEditable(false)
        updateFromProjectModel()
    }
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    /// Updates the contents of the `textView` with `projectModel.listing`.
    func updateFromProjectModel() {
        textView.setText(projectModel.listing)
    }
    
}
