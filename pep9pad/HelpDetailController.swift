//
//  HelpDetailController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class HelpDetailController: UIViewController {

    
    internal var master: HelpMasterController!
    internal var documentationVC: DocumentationViewController!
    internal var exampleVC: ExampleViewController!
    internal var scrollView: UIScrollView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate the detail view controllers
        documentationVC = storyboard?.instantiateViewController(withIdentifier: "DocumentationViewController") as! DocumentationViewController
        exampleVC = storyboard?.instantiateViewController(withIdentifier: "ExampleViewController") as! ExampleViewController
        
        // add the view controllers as childViewControllers
        self.addChildViewController(documentationVC)
        self.addChildViewController(exampleVC)
        documentationVC.didMove(toParentViewController: self)
        exampleVC.didMove(toParentViewController: self)
        
        // set the views up and add them
        documentationVC.view.bounds = self.view.bounds
        exampleVC.view.bounds = self.view.bounds
        view.addSubview(documentationVC.view)
        view.addSubview(exampleVC.view)
        exampleVC.view.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(master: HelpMasterController) {
        self.master = master
        self.master.codeSide.exampleVC = exampleVC
        self.master.codeSide.documentationVC = documentationVC
        
        // load default detail view
        self.master.codeSide.loadDefault()
    }
    
    
    // MARK: - Interface
    
    @IBOutlet weak var copyToBtn: UIBarButtonItem!
    
    @IBAction func copyToBtnPressed(_ sender: UIBarButtonItem) {
        // if pressed, load the current object or source into the project
        master.loadExample(self.exampleVC.currentExampleText,
                           ofType: self.exampleVC.currentExampleType,
                           io: self.exampleVC.currentExampleIO,
                           usesTerminal: self.exampleVC.currentExampleRequiresTerminal)
    }

    
    // MARK: - Methods
    
    internal func loadDocumentation(_ doc: Documentation) {
        master.codeSide.loadDocumentation(doc)
        copyToBtn.isEnabled = false
    }
    
    internal func loadExample(_ named: String) {
        copyToBtn.isEnabled = true
        copyToBtn.title = master.codeSide.loadExample(named) // loads example and sets button title
    }
    
    
    
    
    
    
    
    
}
