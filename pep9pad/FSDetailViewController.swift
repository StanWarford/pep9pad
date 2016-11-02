//
//  FSDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/6/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class FSDetailViewController: UIViewController {
    
    var nameOfDisplayedFile: String!
    var master: FSMasterViewController!

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        // get ref to master and save to local `master` property
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! FSMasterViewController
    }
    
    // MARK: - Methods
    
    internal func loadFile(_ named: String) {
        if let file: FSEntity = loadFileFromFS(named: named) {
            textView.loadText(file.source)
            nameOfDisplayedFile = named
        } else {
            nameOfDisplayedFile = nil
        }
    }
    
    internal func clear() {
        textView.loadText("")
        nameOfDisplayedFile = nil
    }
    
    // MARK: - IBOutlets and IBActions
    
    @IBAction func openBtnPressed(_ sender: UIBarButtonItem) {
        if let _ = nameOfDisplayedFile {
            if editorModel.loadExistingFile(named: nameOfDisplayedFile) {
                // file load was successful, so dismiss this set of viewcontrollers
                self.dismiss(animated: true, completion: nil)
                master.dismiss(animated: true, completion: nil)
            } else {
                print("File load unsuccessful")
            }
        } else {
            print("Cannot load file with no name.")
        }
    }
    
    @IBOutlet weak var textView: PepTextView!
    
    
}
