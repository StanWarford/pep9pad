//
//  FSDetailController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class FSDetailController: UIViewController {
    
    var nameOfDisplayedFile: String!
    var master: FSMasterController!

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.bounds, highlightAs: .pep)
        // get ref to master and save to local `master` property
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! FSMasterController
    }
    
    // MARK: - Methods
    
    internal func loadFile(_ named: String) {
        if let file: P9Project = p9FileSystem.loadProject(named: named) {
            textView.setText(file.source)
            nameOfDisplayedFile = named
        } else {
            nameOfDisplayedFile = nil
        }
    }
    
    internal func clear() {
        textView.setText("")
        nameOfDisplayedFile = nil
    }
    
    // MARK: - IBOutlets and IBActions
    
    @IBAction func openBtnPressed(_ sender: UIBarButtonItem) {
        if let n = nameOfDisplayedFile {
            if projectModel.loadExistingProject(named: n) {
                master.asmDetail.updateEditorsFromProjectModel()
                // file load was successful
                // dismiss this set of viewcontrollers
                self.dismiss(animated: true, completion: nil)
                master.dismiss(animated: true, completion: nil)
            } else {
                print("File load unsuccessful")
            }
        } else {
            print("Cannot load file with no name.")
        }
    }
    
    @IBOutlet weak var textView: CodeView!
    
    
}
