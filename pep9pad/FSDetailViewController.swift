//
//  FSDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/6/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class FSDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
    }
    
    internal func loadFile(_ named: String) {
        if let file = loadFileFromFS(named: named) {
            textView.loadText(file.source)
        }
    }
    
    // MARK: - IBOutlets and IBActions
    
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBOutlet weak var textView: PepTextView!
    
    
}
