//
//  CPUSplitController.swift
//  pep9pad
//
//  Created by Stan Warford on 2/8/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
class CPUSplitController: UIViewController, ProjectModelEditor, CodeViewDelegate {
    
    // MARK: - ViewController Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame, delegate: self, highlightAs: .other)
    }
    
    
    // MARK: - IBOutlets -
    @IBOutlet var textView: CodeView!
    
    
    
    // MARK: - Methods -
    /// Updates this VC to be consistent with the bus size in the cpuProjectModel.
    func busSizeChanged() {
        print("split controller will update accordingly")
    }
    
    
    
    // MARK: - Conformance to ProjectModelEditor -
    
    /// Updates the contents of the `textView` with `projectModel.sourceStr`.
    func pullFromProjectModel() {
        textView.setText(cpuProjectModel.sourceStr)
    }
    
    /// Updates `projectModel.sourceStr` with the contents of `textView`.
    func pushToProjectModel() {
        cpuProjectModel.receiveChanges(from: self, text: textView.getText())
    }
    
    
    // MARK: - Conformance to CodeViewDelegate -
    func textViewDidChange() {
        pushToProjectModel()
    }
    
}
