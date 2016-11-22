//
//  ASMObjectCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_ObjectViewController: UIViewController, ASM_ProjectModelEditor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        updateFromProjectModel()

    }
    
    // MARK: - Interface
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    /// Updates the contents of the `textView` with `projectModel.source`.
    func updateFromProjectModel() {
        textView.setText(projectModel.object)
    }
    
}
