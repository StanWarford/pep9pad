//
//  ListingController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ListingController: UIViewController, ProjectModelEditor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        textView.setEditable(false)
        pullFromProjectModel()
    }
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: CodeView!
    
    /// Updates the contents of the `textView` with `projectModel.listingStr`.
    func pullFromProjectModel() {
        textView.setText(projectModel.listingStr)
    }
    
    /// Updates `projectModel.listingStr` with the contents of `textView`.
    /// **NOTE: This function should never be called.  The user does not have permission to edit the listing.**
    func pushToProjectModel() {
        projectModel.receiveChanges(from: self, text: textView.getText())
    }
    
}
