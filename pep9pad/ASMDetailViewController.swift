//
//  ASMDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/4/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift


class ASMDetailViewController: UIViewController, UITabBarDelegate {
    internal var master: ASMMasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get ref to master and save to local `master` property
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! ASMMasterViewController
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Conformance to UITabBarDelegate
    
    func customizeTabBarImages(_ tabBarItems: [UITabBarItem]) {
        let defaultSize = CGSize(width: 30, height: 30)
        for idx in 0..<tabBarItems.count {
            tabBarItems[idx].image = UIImage.fontAwesomeIconWithName(.Code, textColor: .black, size: defaultSize)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "embedTagBar":
                // the storyboard is hooking up the ASMTabBar
                print("Embedding the tab bar")
                let tbc = segue.destination as! UITabBarController
                customizeTabBarImages((tbc.tabBar.items)! as [UITabBarItem])

            default:
                break
                
            }
        }
    }
    
    
    
    // MARK: - IBOutlets
    
    /// Convenience function that sets the `title` property of a `UIBarButtonItem` to a `FontAwesome` icon.
    func setButtonIcon(forBarBtnItem btn: UIBarButtonItem, nameOfIcon: FontAwesome, ofSize: CGFloat) {
        let attrs = [NSFontAttributeName: UIFont.fontAwesomeOfSize(ofSize)] as Dictionary!
        btn.setTitleTextAttributes(attrs, for: .normal)
        btn.title = String.fontAwesomeIconWithName(nameOfIcon)
    }
    
    
    @IBOutlet var runBtn: UIBarButtonItem!
    @IBOutlet var debugBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.debugBtn, nameOfIcon: .Bug, ofSize: 20)
        }
    }
    @IBOutlet var buildBtn: UIBarButtonItem!
    @IBOutlet var calcBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.calcBtn, nameOfIcon: .Calculator, ofSize: 20)
        }
    }
    @IBOutlet var settingsBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.settingsBtn, nameOfIcon: .Cog, ofSize: 20)
        }
    }
    @IBOutlet var actionBtn: UIBarButtonItem!
    
    
    //MARK: - IBActions
    
    @IBAction func runBtnPressed(_ sender: UIBarButtonItem) {
        //TODO: Implement
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
    
    @IBAction func actionBtnPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: "Open Project", style: .default) { (action) in
            //TODO: Implement openAction
            let fsStoryboard = UIStoryboard.init(name: "FileSystem", bundle: Bundle.main)
            self.present(fsStoryboard.instantiateInitialViewController()!, animated: true, completion: nil)
        }
        alertController.addAction(openAction)
        
        let saveAction = UIAlertAction(title: "Save Project", style: .default) { (action) in
            //TODO: Implement exportSourceAction
        }
        alertController.addAction(saveAction)
        
        let shareAction = UIAlertAction(title: "Share Project", style: .default) { (action) in
            //TODO: Implement exportObjectAction
        }
        alertController.addAction(shareAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func settingsBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let formatFromListingAction = UIAlertAction(title: "Format From Listing", style: .default) { (action) in
            //TODO: Implement formatFromListingAction
        }
        alertController.addAction(formatFromListingAction)
        
        let removeErrorMsgsAction = UIAlertAction(title: "Remove Error Messages", style: .default) { (action) in
            //TODO: Implement removeErrorMsgsAction
        }
        alertController.addAction(removeErrorMsgsAction)
        
        let clearMemAction = UIAlertAction(title: "Clear Memory", style: .default) { (action) in
            //TODO: Implement clearMemAction
        }
        alertController.addAction(clearMemAction)
        
        let redefineMnemonicsAction = UIAlertAction(title: "Redefine Mnemonics", style: .default) { (action) in
            //TODO: Implement redefineMnemonicsAction
        }
        alertController.addAction(redefineMnemonicsAction)
        
        let installNewOSAction = UIAlertAction(title: "Install New OS", style: .default) { (action) in
            //TODO: Implement installNewOSAction
        }
        alertController.addAction(installNewOSAction)
        
        let reinstallDefaultOSAction = UIAlertAction(title: "Reinstall Default OS", style: .default) { (action) in
            //TODO: Implement reinstallDefaultOSAction
        }
        alertController.addAction(reinstallDefaultOSAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)

    }
    
}
