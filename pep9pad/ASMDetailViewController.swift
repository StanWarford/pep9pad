//
//  ASMDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/4/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASMDetailViewController: UIViewController {
    internal var master: ASMMasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! ASMMasterViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet var buildBtn: UIBarButtonItem!
    @IBOutlet var debugBtn: UIBarButtonItem!
    @IBOutlet var exportBtn: UIBarButtonItem!
    
    @IBAction func buildBtnPressed(_ sender: UIBarButtonItem) {
        //TODO: Implement
    }
    
    @IBAction func debugBtnPressed(_ sender: UIBarButtonItem) {
        //TODO: Implement

    }
    
    @IBAction func exportBtnPressed(_ sender: UIBarButtonItem) {
        //TODO: Implement
/*
        let alertController = UIAlertController(title: "Export", message: "This graph can be exported to a .pdf (e-mail attachment) or .jpg (to your device's camera roll).", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let pdfAction = UIAlertAction(title: "PDF", style: .Default) { (action) in
            // ...
            self.shareCenter.exportGraphToPDF()
        }
        alertController.addAction(pdfAction)
        
        let imageAction = UIAlertAction(title: "Image", style: .Default) { (action) in
            print(action)
            self.shareCenter.exportGraphToImg()
        }
        alertController.addAction(imageAction)
        alertController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        self.presentViewController(alertController, animated: true, completion: nil)
 */

    }

}
