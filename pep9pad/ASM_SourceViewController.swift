//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/12/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_SourceViewController: UIViewController, ASM_EditorProtocol {
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        updateFromModel()
    }
    
    
    
    // MARK: - Interface Builder
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    
    // MARK: - Methods
    
    func assemble() -> Bool {
        // PLACEHOLDER
        return true
    }
    
    /// Updates the contents of the `textView` with `editorModel.source`.
    func updateFromModel() {
        textView.setText(editorModel.source)
    }
    
    
    

    
}
