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
        pullFromProjectModel()
    }
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    /// Updates the contents of the `textView` with `projectModel.listingStr`.
    func pullFromProjectModel() {
        textView.setText(projectModel.listingStr)
    }
    
    /// Updates `projectModel.listingStr` with the contents of `textView`.
    func pushToProjectModel() {
        projectModel.receiveChanges(from: self, text: textView.getText())
    }
    
}
