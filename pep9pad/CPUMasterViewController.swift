//
//  CPUMasterViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class CPUMasterController: UIViewController {
    
    internal var detail: CPUDetailController!
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailnc = (self.splitViewController?.viewControllers[1])! as! UINavigationController
        self.detail = (detailnc.viewControllers[0] as UIViewController) as! CPUDetailController
    }
    
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        detail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

}
