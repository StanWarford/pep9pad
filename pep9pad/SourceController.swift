//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class SourceController: UIViewController, ProjectModelEditor, PepTextViewDelegate {
    
    
    // MARK: - Properties
    var sourceCode: [Code] = []
    var objectCode: [Int] = []
    var assemblerListing: [String] = []
    var listingTrace: [String] = []
    var hasCheckBox: [Bool] = []
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame, delegate: self)
        pullFromProjectModel()
    }
    
    
    
    // MARK: - Interface Builder
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    
    // MARK: - Methods
    
    // Post: Searces for the string ";ERROR: " on each line and removes the end of the line.
    // Post: Searces for the string ";WARNING: " on each line and removes the end of the line.
    func removeErrorMessages() {
        
    }
    
    // Post: Appends message to the end of line lineNumber in a reserved color.
    func appendMessageInSourceCodeAt(lineNumber: Int, message: String) {
        
    }
    
    // Post: Sets text in source code pane to `str`.
    func setSourceCode(to str: String) {
        
    }
    
    // Post: Clears the textView.
    func clear() {
        
    }
    
    
    // MARK: - Conformance to ProjectModelEditor
    
    /// Updates the contents of the `textView` with `projectModel.sourceStr`.
    func pullFromProjectModel() {
        textView.setText(projectModel.sourceStr)
    }
    
    /// Updates `projectModel.sourceStr` with the contents of `textView`.
    func pushToProjectModel() {
        projectModel.receiveChanges(from: self, text: textView.getText())
    }
    
    
    // MARK: - Conformance to PepTextViewDelegate
    func textViewDidChange() {
        pushToProjectModel()
    }
    
    

    
}
