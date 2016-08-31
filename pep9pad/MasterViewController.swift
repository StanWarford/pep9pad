//
//  ViewController.swift
//  pep9pad
//
//  Created by Stan Warford on 2/24/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    internal var detail: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let detailnc = (self.splitViewController?.viewControllers[1])! as! UINavigationController
        self.detail = detailnc.viewControllers[0] as UIViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var cpuContainerView: UIView!
    
    @IBAction func homeButtonPressed(sender: UIBarButtonItem) {
        detail.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

