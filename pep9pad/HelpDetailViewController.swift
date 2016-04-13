//
//  HelpDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/8/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class HelpDetailViewController: UIViewController {

    internal var documentationVC: DocumentationViewController!
    internal var doubleVC: DoubleTextViewController!
    
    internal var fullRect: CGRect!
    
    @IBOutlet weak var copyToSourceBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarHeight = self.navigationController?.navigationBar.bounds.height
        let fullRect = CGRectMake(view.bounds.origin.x, view.bounds.origin.y + 20 + navBarHeight!, view.bounds.width-320, view.bounds.height - 20 - navBarHeight!)
        
        // instantiate the detail view controllers
        documentationVC = storyboard?.instantiateViewControllerWithIdentifier("DocumentationViewController") as! DocumentationViewController
        doubleVC = storyboard?.instantiateViewControllerWithIdentifier("DoubleTextViewController") as! DoubleTextViewController
        // add the view controllers as childViewControllers
        self.addChildViewController(documentationVC)
        self.addChildViewController(doubleVC)
        documentationVC.didMoveToParentViewController(self)
        doubleVC.didMoveToParentViewController(self)
        documentationVC.view.bounds = self.view.bounds
        doubleVC.view.bounds = self.view.bounds
        view.addSubview(documentationVC.view)
        view.addSubview(doubleVC.view)
        
        doubleVC.view.hidden = true
        
        loadDocumentation(.AssemblyLanguage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    internal func loadDocumentation(doc: Documentation) {
        documentationVC.view.hidden = false
        doubleVC.view.hidden = true
        let url = NSBundle.mainBundle().URLForResource(doc.rawValue, withExtension:"html")
        let request = NSURLRequest(URL: url!)
        documentationVC.doc.loadRequest(request)
        copyToSourceBtn.enabled = false
    }
    
    internal func loadExample(named: String) {
        documentationVC.view.hidden = true
        doubleVC.view.hidden = false
        copyToSourceBtn.enabled = true

        switch named {
        case "Figure 4.33":
            doubleVC.leftTextView.loadExample("fig0433", ofType: .pepb)
            doubleVC.rightTextView.loadExample("fig0433", ofType: .peph)
        case "Figure 4.35":
            doubleVC.leftTextView.loadExample("fig0435", ofType: .pepb)
            doubleVC.rightTextView.loadExample("fig0435", ofType: .peph)
        case "Figure 4.36":
            doubleVC.leftTextView.loadExample("fig0436", ofType: .pepb)
            doubleVC.rightTextView.loadExample("fig0436", ofType: .peph)
        case "Figure 4.37":
            doubleVC.leftTextView.loadExample("fig0437", ofType: .pepb)
            doubleVC.rightTextView.loadExample("fig0437", ofType: .peph)
        case "Figure 5.03":
            doubleVC.leftTextView.loadExample("fig0503", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0433", ofType: .peph)
        case "Figure 5.06":
            doubleVC.leftTextView.loadExample("fig0506", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0435", ofType: .peph)
        case "Figure 5.07":
            doubleVC.leftTextView.loadExample("fig0507", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0436", ofType: .peph)
        case "Figure 5.10":
            doubleVC.leftTextView.loadExample("fig0510", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.11":
            doubleVC.leftTextView.loadExample("fig0511", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.12":
            doubleVC.leftTextView.loadExample("fig0512", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.13":
            doubleVC.leftTextView.loadExample("fig0513", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.14a":
            doubleVC.leftTextView.loadExample("fig0514a", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.14b":
            doubleVC.leftTextView.loadExample("fig0514b", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.15":
            doubleVC.leftTextView.loadExample("fig0515", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0512", ofType: .pep)
        case "Figure 5.16":
            doubleVC.leftTextView.loadExample("fig0516", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 5.19":
            doubleVC.leftTextView.loadExample("fig0519", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0519", ofType: .c)
        case "Figure 5.22":
            doubleVC.leftTextView.loadExample("fig0522", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0522", ofType: .c)
        case "Figure 5.27":
            doubleVC.leftTextView.loadExample("fig0527", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0527", ofType: .c)
        case "Figure 6.01":
            doubleVC.leftTextView.loadExample("fig0601", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 6.04":
            doubleVC.leftTextView.loadExample("fig0604", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0604", ofType: .c)
        case "Figure 6.06":
            doubleVC.leftTextView.loadExample("fig0606", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0606", ofType: .c)
        case "Figure 6.08":
            doubleVC.leftTextView.loadExample("fig0608", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0608", ofType: .c)
        case "Figure 6.10":
            doubleVC.leftTextView.loadExample("fig0610", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0610", ofType: .c)
        case "Figure 6.12":
            doubleVC.leftTextView.loadExample("fig0612", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0612", ofType: .c)
        case "Figure 6.14":
            doubleVC.leftTextView.loadExample("fig0614", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0614", ofType: .c)
        case "Figure 6.16":
            doubleVC.leftTextView.loadExample("fig0616", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Figure 6.18":
            doubleVC.leftTextView.loadExample("fig0618", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0618", ofType: .c)
        case "Figure 6.21":
            doubleVC.leftTextView.loadExample("fig0621", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0621", ofType: .c)
        case "Figure 6.23":
            doubleVC.leftTextView.loadExample("fig0623", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0623", ofType: .c)
        case "Figure 6.25":
            doubleVC.leftTextView.loadExample("fig0625", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0625", ofType: .c)
        case "Figure 6.27":  // Interactive input
            doubleVC.leftTextView.loadExample("fig0627", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0627", ofType: .c)
        case "Figure 6.29":   // Interactive input
            doubleVC.leftTextView.loadExample("fig0629", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0629", ofType: .c)
        case "Figure 6.32":
            doubleVC.leftTextView.loadExample("fig0632", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0632", ofType: .c)
        case "Figure 6.34":
            doubleVC.leftTextView.loadExample("fig0634", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0634", ofType: .c)
        case "Figure 6.36":
            doubleVC.leftTextView.loadExample("fig0636", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0636", ofType: .c)
        case "Figure 6.38":
            doubleVC.leftTextView.loadExample("fig0638", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0638", ofType: .c)
        case "Figure 6.40":  // Interactive input
            doubleVC.leftTextView.loadExample("fig0640", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0640", ofType: .c)
        case "Figure 6.42":
            doubleVC.leftTextView.loadExample("fig0642", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0642", ofType: .c)
        case "Figure 6.44":
            doubleVC.leftTextView.loadExample("fig0644", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0644", ofType: .c)
        case "Figure 6.46":
            doubleVC.leftTextView.loadExample("fig0646", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0646", ofType: .c)
        case "Figure 6.48":
            doubleVC.leftTextView.loadExample("fig0648", ofType: .pep)
            doubleVC.rightTextView.loadExample("fig0648", ofType: .c)
        case "Exercise 8.04":
            doubleVC.leftTextView.loadExample("exer0804", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.26":
            doubleVC.leftTextView.loadExample("prob0826", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.27":
            doubleVC.leftTextView.loadExample("prob0827", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.28":
            doubleVC.leftTextView.loadExample("prob0828", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.29":
            doubleVC.leftTextView.loadExample("prob0829", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.30":
            doubleVC.leftTextView.loadExample("prob0830", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.31":
            doubleVC.leftTextView.loadExample("prob0831", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        case "Problem 8.32":
            doubleVC.leftTextView.loadExample("prob0832", ofType: .pep)
            doubleVC.rightTextView.text.removeAll()
        default:
            doubleVC.leftTextView.text.removeAll()
            doubleVC.rightTextView.text.removeAll()
        }
    }
    
    
    
}
