//
//  HelpDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/8/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class HelpDetailViewController: UIViewController {

    
    internal var master: HelpMasterViewController!
    internal var documentationVC: DocumentationViewController!
    internal var exampleVC: ExampleViewController!
    
    internal let copyToObj: String = "Copy to Object"
    internal let copyToSrc: String = "Copy to Source"
    
    
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
    
        // load default detail view
        loadDocumentation(.AssemblyLanguage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(master: HelpMasterViewController) {
        self.master = master
    }
    
    
    // MARK: - Interface
    
    @IBOutlet weak var copyToSourceBtn: UIBarButtonItem!
    
    @IBAction func copyToSourceBtnPressed(_ sender: UIBarButtonItem) {
        // if pressed, load the current source into the project
        
        master.loadExample(self.exampleVC.currentExampleText, ofType: self.exampleVC.currentExampleType, io: self.exampleVC.currentExampleIO, usesTerminal: self.exampleVC.currentExampleRequiresTerminal)

    }

    
    // MARK: - Methods
    
    internal func loadDocumentation(_ doc: Documentation) {
        documentationVC.view.isHidden = false
        exampleVC.view.isHidden = true
        let url = Bundle.main.url(forResource: doc.rawValue, withExtension:"html")
        let request = URLRequest(url: url!)
        documentationVC.doc.loadRequest(request)
        copyToSourceBtn.isEnabled = false
    }
    
    internal func loadExample(_ named: String) {
        documentationVC.view.isHidden = true
        exampleVC.view.isHidden = false
        copyToSourceBtn.isEnabled = true

        switch named {
        case "Figure 4.33":
            exampleVC.loadExample("fig0433", field: .Top, ofType: .peph)
            exampleVC.loadExample("fig0433", field: .Bottom, ofType: .pepb)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToObj
        case "Figure 4.35":
            exampleVC.loadExample("fig0435", field: .Top, ofType: .peph)
            exampleVC.loadExample("fig0435", field: .Bottom, ofType: .pepb)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("up")
            copyToSourceBtn.title = copyToObj
        case "Figure 4.36":
            exampleVC.loadExample("fig0436", field: .Top, ofType: .peph)
            exampleVC.loadExample("fig0436", field: .Bottom, ofType: .pepb)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToObj
        case "Figure 4.37":
            exampleVC.loadExample("fig0437", field: .Top, ofType: .peph)
            exampleVC.loadExample("fig0437", field: .Bottom, ofType: .pepb)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToObj
        case "Figure 5.03":
            exampleVC.loadExample("fig0503", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0433", field: .Bottom, ofType: .peph)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.06":
            exampleVC.loadExample("fig0506", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0435", field: .Bottom, ofType: .peph)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("up")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.07":
            exampleVC.loadExample("fig0507", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0436", field: .Bottom, ofType: .peph)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.10":
            exampleVC.loadExample("fig0510", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()            
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.11":
            exampleVC.loadExample("fig0511", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("-479")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.12":
            exampleVC.loadExample("fig0512", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("-479")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.13":
            exampleVC.loadExample("fig0513", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.14a":
            exampleVC.loadExample("fig0514a", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.14b":
            exampleVC.loadExample("fig0514b", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.15":
            exampleVC.loadExample("fig0515", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0512", field: .Bottom, ofType: .pep)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("-479")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.16":
            exampleVC.loadExample("fig0516", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.19":
            exampleVC.loadExample("fig0519", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0519", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.22":
            exampleVC.loadExample("fig0522", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0522", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("M 419")
            copyToSourceBtn.title = copyToSrc
        case "Figure 5.27":
            exampleVC.loadExample("fig0527", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0527", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("68 84")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.01":
            exampleVC.loadExample("fig0601", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.04":
            exampleVC.loadExample("fig0604", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0604", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("68 84")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.06":
            exampleVC.loadExample("fig0606", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0606", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("-25")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.08":
            exampleVC.loadExample("fig0608", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0608", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("75")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.10":
            exampleVC.loadExample("fig0610", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0610", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("Hello, world!*")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.12":
            exampleVC.loadExample("fig0612", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0612", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.14":
            exampleVC.loadExample("fig0614", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0614", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.16":
            exampleVC.loadExample("fig0616", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("3 -15 25")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.18":
            exampleVC.loadExample("fig0618", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0618", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.21":
            exampleVC.loadExample("fig0621", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0621", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("12  3 13 17 34 27 23 25 29 16 10 0 2")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.23":
            exampleVC.loadExample("fig0623", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0623", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("12  3 13 17 34 27 23 25 29 16 10 0 2")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.25":
            exampleVC.loadExample("fig0625", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0625", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.27":  // Interactive input
            exampleVC.loadExample("fig0627", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0627", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleTerminalIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.29":   // Interactive input
            exampleVC.loadExample("fig0629", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0629", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleTerminalIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.32":
            exampleVC.loadExample("fig0632", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0632", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("25")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.34":
            exampleVC.loadExample("fig0634", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0634", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("60 70 80 90")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.36":
            exampleVC.loadExample("fig0636", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0636", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("2 26 -3 9")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.38":
            exampleVC.loadExample("fig0638", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0638", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("5  40 50 60 70 80")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.40":  // Interactive input
            exampleVC.loadExample("fig0640", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0640", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleTerminalIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.42":
            exampleVC.loadExample("fig0642", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0642", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.44":
            exampleVC.loadExample("fig0644", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0644", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.46":
            exampleVC.loadExample("fig0646", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0646", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("bj 32 m")
            copyToSourceBtn.title = copyToSrc
        case "Figure 6.48":
            exampleVC.loadExample("fig0648", field: .Top, ofType: .pep)
            exampleVC.loadExample("fig0648", field: .Bottom, ofType: .c)
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("10 20 30 40 -9999")
            copyToSourceBtn.title = copyToSrc
        case "Exercise 8.04":
            exampleVC.loadExample("exer0804", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("37")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.26":
            exampleVC.loadExample("prob0826", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("7")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.27":
            exampleVC.loadExample("prob0827", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("7 3")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.28":
            exampleVC.loadExample("prob0828", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("5 9")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.29":
            exampleVC.loadExample("prob0829", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.30":
            exampleVC.loadExample("prob0830", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.31":
            exampleVC.loadExample("prob0831", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("12 7")
            copyToSourceBtn.title = copyToSrc
        case "Problem 8.32":
            exampleVC.loadExample("prob0832", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("32773 6")
            copyToSourceBtn.title = copyToSrc
        case "Pep/9 Operating System":
            exampleVC.loadExample("pep9os", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc

        default:
            exampleVC.topTextView.removeAllText()
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setNumTextViews(to: 2)
            exampleVC.setExampleIO("")
            copyToSourceBtn.title = copyToSrc
        }
    }
    
    
    
    
    
    
    
    
}
