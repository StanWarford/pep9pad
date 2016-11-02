//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/12/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_SourceViewController: UIViewController {
    
    let defaultFileName: String = "My First Program"

    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        self.loadDefaultFile()
    }
    
    // MARK: - Interface Builder
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    // MARK: - Methods
    
    func assemble() -> Bool {
        // PLACEHOLDER
        return true
    }
    
    func loadDefaultFile() {
        if let file = loadFileFromFS(named: defaultFileName) {
            textView.loadText(file.source)
            let _ = editorModel.loadExistingFile(named: defaultFileName)

        }
        
    }
    

    
}
