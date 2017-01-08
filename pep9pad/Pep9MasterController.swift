//
//  Pep9MasterController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class Pep9MasterController: UIViewController {
    
    internal var detail: Pep9DetailController!
    internal var cpu: CpuController!
    internal var io: IOMemController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let detailnc = (self.splitViewController?.viewControllers[1])! as! UINavigationController
        self.detail = detailnc.viewControllers[0] as! Pep9DetailController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cpuEmbedSegue" {
            self.cpu = segue.destination as? CpuController
        } else if segue.identifier == "ioEmbedSegue" {
            self.io = segue.destination as? IOMemController
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
                let hm = nav.viewControllers[0] as! HelpMasterController
                hm.setup(mvc: self)
                
            }
        }
    }
    
    /// Loads an example from the Help system into the appropriate view in `detail`.
    func loadExample(_ text: String, ofType: PepFileType, io: String!, usesTerminal: Bool) {
        // if the load is successful, set the io properties
        if detail.attemptToLoadExample(text: text, ofType: ofType) {
            self.io.setMode(to: usesTerminal ? .terminalIO : .batchIO)
            self.io.setInput(io)
        }
    }

    
    

}

