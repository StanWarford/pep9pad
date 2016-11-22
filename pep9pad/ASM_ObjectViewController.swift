//
//  ASMObjectCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_ObjectViewController: UIViewController, ASM_ProjectModelEditor, PepTextViewDelegate {
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame, delegate: self)
        pullFromProjectModel()

    }
    
    // MARK: - IBOutlets and Actions
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    
    
    
    // MARK: - Conformance to ASM_ProjectModelEditor
    
    /// Updates the contents of the `textView` with `projectModel.object`.
    func pullFromProjectModel() {
        textView.setText(projectModel.object)
    }
    
    /// Updates `projectModel.object` with the contents of `textView`.
    func pushToProjectModel() {
        projectModel.receiveChanges(pushedFrom: self, text: textView.getText())
    }
    
    
    
    
    // MARK: - Conformance to PepTextViewDelegate
    
    func textViewDidChange() {
        pushToProjectModel()
    }
    
    
}
