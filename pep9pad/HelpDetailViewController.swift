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
        let fullRect = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + 20 + navBarHeight!, width: view.bounds.width-320, height: view.bounds.height - 20 - navBarHeight!)
        
        // instantiate the detail view controllers
        documentationVC = storyboard?.instantiateViewController(withIdentifier: "DocumentationViewController") as! DocumentationViewController
        doubleVC = storyboard?.instantiateViewController(withIdentifier: "DoubleTextViewController") as! DoubleTextViewController
        // add the view controllers as childViewControllers
        self.addChildViewController(documentationVC)
        self.addChildViewController(doubleVC)
        documentationVC.didMove(toParentViewController: self)
        doubleVC.didMove(toParentViewController: self)
        documentationVC.view.bounds = self.view.bounds
        doubleVC.view.bounds = self.view.bounds
        view.addSubview(documentationVC.view)
        view.addSubview(doubleVC.view)
        
        doubleVC.view.isHidden = true
        
        loadDocumentation(.AssemblyLanguage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    internal func loadDocumentation(_ doc: Documentation) {
        documentationVC.view.isHidden = false
        doubleVC.view.isHidden = true
        let url = Bundle.main.url(forResource: doc.rawValue, withExtension:"html")
        let request = URLRequest(url: url!)
        documentationVC.doc.loadRequest(request)
        copyToSourceBtn.isEnabled = false
    }
    
    internal func loadExample(_ named: String) {
        documentationVC.view.isHidden = true
        doubleVC.view.isHidden = false
        copyToSourceBtn.isEnabled = true

        switch named {
        case "Figure 4.33":
            doubleVC.topTextView.loadExample("fig0433", ofType: .pepb)
            doubleVC.bottomTextView.loadExample("fig0433", ofType: .peph)
        case "Figure 4.35":
            doubleVC.topTextView.loadExample("fig0435", ofType: .pepb)
            doubleVC.bottomTextView.loadExample("fig0435", ofType: .peph)
        case "Figure 4.36":
            doubleVC.topTextView.loadExample("fig0436", ofType: .pepb)
            doubleVC.bottomTextView.loadExample("fig0436", ofType: .peph)
        case "Figure 4.37":
            doubleVC.topTextView.loadExample("fig0437", ofType: .pepb)
            doubleVC.bottomTextView.loadExample("fig0437", ofType: .peph)
        case "Figure 5.03":
            doubleVC.topTextView.loadExample("fig0503", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0433", ofType: .peph)
        case "Figure 5.06":
            doubleVC.topTextView.loadExample("fig0506", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0435", ofType: .peph)
        case "Figure 5.07":
            doubleVC.topTextView.loadExample("fig0507", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0436", ofType: .peph)
        case "Figure 5.10":
            doubleVC.topTextView.loadExample("fig0510", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.11":
            doubleVC.topTextView.loadExample("fig0511", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.12":
            doubleVC.topTextView.loadExample("fig0512", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.13":
            doubleVC.topTextView.loadExample("fig0513", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.14a":
            doubleVC.topTextView.loadExample("fig0514a", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.14b":
            doubleVC.topTextView.loadExample("fig0514b", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.15":
            doubleVC.topTextView.loadExample("fig0515", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0512", ofType: .pep)
        case "Figure 5.16":
            doubleVC.topTextView.loadExample("fig0516", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 5.19":
            doubleVC.topTextView.loadExample("fig0519", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0519", ofType: .c)
        case "Figure 5.22":
            doubleVC.topTextView.loadExample("fig0522", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0522", ofType: .c)
        case "Figure 5.27":
            doubleVC.topTextView.loadExample("fig0527", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0527", ofType: .c)
        case "Figure 6.01":
            doubleVC.topTextView.loadExample("fig0601", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 6.04":
            doubleVC.topTextView.loadExample("fig0604", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0604", ofType: .c)
        case "Figure 6.06":
            doubleVC.topTextView.loadExample("fig0606", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0606", ofType: .c)
        case "Figure 6.08":
            doubleVC.topTextView.loadExample("fig0608", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0608", ofType: .c)
        case "Figure 6.10":
            doubleVC.topTextView.loadExample("fig0610", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0610", ofType: .c)
        case "Figure 6.12":
            doubleVC.topTextView.loadExample("fig0612", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0612", ofType: .c)
        case "Figure 6.14":
            doubleVC.topTextView.loadExample("fig0614", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0614", ofType: .c)
        case "Figure 6.16":
            doubleVC.topTextView.loadExample("fig0616", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Figure 6.18":
            doubleVC.topTextView.loadExample("fig0618", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0618", ofType: .c)
        case "Figure 6.21":
            doubleVC.topTextView.loadExample("fig0621", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0621", ofType: .c)
        case "Figure 6.23":
            doubleVC.topTextView.loadExample("fig0623", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0623", ofType: .c)
        case "Figure 6.25":
            doubleVC.topTextView.loadExample("fig0625", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0625", ofType: .c)
        case "Figure 6.27":  // Interactive input
            doubleVC.topTextView.loadExample("fig0627", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0627", ofType: .c)
        case "Figure 6.29":   // Interactive input
            doubleVC.topTextView.loadExample("fig0629", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0629", ofType: .c)
        case "Figure 6.32":
            doubleVC.topTextView.loadExample("fig0632", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0632", ofType: .c)
        case "Figure 6.34":
            doubleVC.topTextView.loadExample("fig0634", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0634", ofType: .c)
        case "Figure 6.36":
            doubleVC.topTextView.loadExample("fig0636", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0636", ofType: .c)
        case "Figure 6.38":
            doubleVC.topTextView.loadExample("fig0638", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0638", ofType: .c)
        case "Figure 6.40":  // Interactive input
            doubleVC.topTextView.loadExample("fig0640", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0640", ofType: .c)
        case "Figure 6.42":
            doubleVC.topTextView.loadExample("fig0642", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0642", ofType: .c)
        case "Figure 6.44":
            doubleVC.topTextView.loadExample("fig0644", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0644", ofType: .c)
        case "Figure 6.46":
            doubleVC.topTextView.loadExample("fig0646", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0646", ofType: .c)
        case "Figure 6.48":
            doubleVC.topTextView.loadExample("fig0648", ofType: .pep)
            doubleVC.bottomTextView.loadExample("fig0648", ofType: .c)
        case "Exercise 8.04":
            doubleVC.topTextView.loadExample("exer0804", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.26":
            doubleVC.topTextView.loadExample("prob0826", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.27":
            doubleVC.topTextView.loadExample("prob0827", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.28":
            doubleVC.topTextView.loadExample("prob0828", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.29":
            doubleVC.topTextView.loadExample("prob0829", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.30":
            doubleVC.topTextView.loadExample("prob0830", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.31":
            doubleVC.topTextView.loadExample("prob0831", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        case "Problem 8.32":
            doubleVC.topTextView.loadExample("prob0832", ofType: .pep)
            doubleVC.bottomTextView.removeAllText()
            doubleVC.bottomTextView.minimize()
        default:
            doubleVC.topTextView.removeAllText()
            doubleVC.bottomTextView.removeAllText()
        }
    }
    
    
    
}
