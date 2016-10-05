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
    
  //MARK: IBOutlets and Actions
    
    @IBOutlet weak var runBtn: UIBarButtonItem!
    @IBOutlet var debugBtn: UIBarButtonItem!
    @IBOutlet var buildBtn: UIBarButtonItem!
    @IBOutlet var exportBtn: UIBarButtonItem!
    
    @IBAction func runBtnPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func debugBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let debugSourceAction = UIAlertAction(title: "Start Debugging Source", style: .default) { (action) in
            //TODO: Implement debugSourceAction
        }
        alertController.addAction(debugSourceAction)
        let debugObjectAction = UIAlertAction(title: "Start Debugging Object", style: .default) { (action) in
            //TODO: Implement debugObjectAction
        }
        alertController.addAction(debugObjectAction)
        let debugLoaderAction = UIAlertAction(title: "Start Debugging Loader", style: .default) { (action) in
            //TODO: Implement debugLoaderAction
        }
        alertController.addAction(debugLoaderAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buildBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let assembleSourceAction = UIAlertAction(title: "Assemble Source", style: .default) { (action) in
            //TODO: Implement assembleSourceAction
        }
        alertController.addAction(assembleSourceAction)
        
        let loadObjectAction = UIAlertAction(title: "Load Object", style: .default) { (action) in
            //TODO: Implement loadObjectAction
        }
        alertController.addAction(loadObjectAction)
        
        let executeAction = UIAlertAction(title: "Execute", style: .default) { (action) in
            //TODO: Implement executeAction
        }
        alertController.addAction(executeAction)
        
        let runObjectAction = UIAlertAction(title: "Run Object", style: .default) { (action) in
            //TODO: Implement runObjectAction
        }
        alertController.addAction(runObjectAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func exportBtnPressed(_ sender: UIBarButtonItem) {
        //TODO: Implement
    }
}
