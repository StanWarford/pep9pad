//
//  ASMObjectCodeViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ObjectController: UIViewController, ProjectModelEditor, PepTextViewDelegate {
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame, delegate: self)
        pullFromProjectModel()

    }
    
    // MARK: - IBOutlets and Actions
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    
    
    
    // MARK: - Conformance to ProjectModelEditor
    
    /// Updates the contents of the `textView` with `projectModel.objectStr`.
    func pullFromProjectModel() {
        textView.setText(projectModel.objectStr)
    }
    
    /// Updates `projectModel.objectStr` with the contents of `textView`.
    func pushToProjectModel() {
        projectModel.receiveChanges(from: self, text: textView.getText())
    }
    
    
    
    
    // MARK: - Conformance to PepTextViewDelegate
    
    func textViewDidChange() {
        pushToProjectModel()
    }
    
    
}
