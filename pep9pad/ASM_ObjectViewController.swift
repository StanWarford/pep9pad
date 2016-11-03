//
//  ASMObjectCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_ObjectViewController: UIViewController, ASM_EditorProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        updateFromModel()

    }
    
    // MARK: - Interface
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    /// Updates the contents of the `textView` with `editorModel.source`.
    func updateFromModel() {
        textView.setText(editorModel.object)
    }
    
}
