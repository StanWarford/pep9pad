//
//  ViewController.swift
//  pep9pad
//
//  Created by Stan Warford on 2/24/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_MasterViewController: UIViewController {
    
    internal var detail: ASM_DetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let detailnc = (self.splitViewController?.viewControllers[1])! as! UINavigationController
        self.detail = detailnc.viewControllers[0] as! ASM_DetailViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var cpuContainerView: UIView!
    
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        detail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

}

