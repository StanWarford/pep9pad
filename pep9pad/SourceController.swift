//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class SourceController: UIViewController, ProjectModelEditor, CodeViewDelegate {
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.bounds, delegate: self, highlightAs: .pep)
        pullFromProjectModel()
    }
    
    
    // MARK: - Interface Builder
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: CodeView!
    
    
    
    // MARK: - Methods
    
    
    // MARK: - Conformance to ProjectModelEditor
    
    /// Updates the contents of the `textView` with `projectModel.sourceStr`.
    func pullFromProjectModel() {
        textView.setText(projectModel.sourceStr)
    }
    
    /// Updates `projectModel.sourceStr` with the contents of `textView`.
    func pushToProjectModel() {
        projectModel.receiveChanges(from: self, text: textView.getText())
    }
    
    
    // MARK: - Conformance to CodeViewDelegate
    func textViewDidChange() {
        pushToProjectModel()
    }
    
    
}
