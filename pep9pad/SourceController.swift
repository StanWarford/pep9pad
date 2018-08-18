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
        let rectForCode = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height-heightOfTabBar)
        textView.setupTextView(rectForCode, delegate: self, highlightAs: .pep)
        pullFromProjectModel()
        // scrolls the textview to the top...?
        textView.textView.scrollRectToVisible(CGRect.zero, animated: true)

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
        // setting isScrollEnabled seems to fix the scrolling issues
        //textView.textView.isScrollEnabled = true
    }
    
    
}
