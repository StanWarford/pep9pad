//
//  CPUMasterViewController.swift
//  pep9pad
//
//  Created by Stan Warford on 9/7/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class CPUMasterViewController: UIViewController {
    
    internal var detail: CPUDetailViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailnc = (self.splitViewController?.viewControllers[1])! as! UINavigationController
        self.detail = (detailnc.viewControllers[0] as UIViewController) as! CPUDetailViewController
    }
    
    @IBAction func homeButtonPressed(sender: UIBarButtonItem) {
        detail.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
