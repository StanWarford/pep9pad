//
//  ASM_MasterViewController.swift
//  pep9pad
//
//  Created by Stan Warford on 2/24/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_MasterViewController: UIViewController {
    
    internal var detail: ASM_DetailViewController!
    internal var cpu: ASM_CPUViewController!
    internal var io: ASM_IOViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let detailnc = (self.splitViewController?.viewControllers[1])! as! UINavigationController
        self.detail = detailnc.viewControllers[0] as! ASM_DetailViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cpuEmbedSegue" {
            self.cpu = segue.destination as? ASM_CPUViewController
        } else if segue.identifier == "ioEmbedSegue" {
            self.io = segue.destination as? ASM_IOViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeBtnPressed(_ sender: UIBarButtonItem) {
        detail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func helpBtnPressed(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Help", bundle: Bundle.main).instantiateInitialViewController()
        self.present(vc!, animated: true) {
            if let spvc = vc as! UISplitViewController? {
                let nav = spvc.viewControllers[0] as! UINavigationController
                let hm = nav.viewControllers[0] as! HelpMasterViewController
                hm.setup(mvc: self)
                
            }
        }
    }
    
    /// Loads an example from the Help system into the appropriate view in `detail`.
    func loadExample(_ text: String, ofType: PepFileType, io: String!, usesTerminal: Bool) {
        // if the load is successful, set the io properties
        if detail.attemptToLoadExample(text: text, ofType: ofType) {
            self.io.setIOMode(to: usesTerminal ? .terminal : .batch)
            self.io.topTextView.text = io
        }
    }

    
    

}

