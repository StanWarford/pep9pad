//
//  CPUDetailViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift



/// A typealias consisting of all elements in the ASM Tab Bar.
typealias CPUTabBarVCs = (split: CPUSplitController?, visual: CPUVisualController?, trace: CPUTraceController?)


class CPUDetailController : UIViewController {
    
    
    internal var master: CPUMasterController!
    internal var tabBar: UITabBarController!
    internal var tabVCs: CPUTabBarVCs = (nil, nil, nil)

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Convenience function that sets the `title` property of a `UIBarButtonItem` to a `FontAwesome` icon.
    func setButtonIcon(forBarBtnItem btn: UIBarButtonItem, nameOfIcon: FontAwesome, ofSize: CGFloat) {
        let attrs = [NSFontAttributeName: UIFont.fontAwesomeOfSize(ofSize)] as Dictionary!
        btn.setTitleTextAttributes(attrs, for: .normal)
        btn.title = String.fontAwesomeIconWithName(nameOfIcon)
    }
    
    
    
    
    // MARK: - Conformance to UITabBarDelegate
    
    func customizeTabBarImages(_ tabBarItems: [UITabBarItem]) {
        // could also work: .Tasks, .TH List, .Server, .Dashboard, .FileText, .SiteMap, .Binoculars, .HDD, .Map, .Tachometer, .Table, .Stethoscope, .Terminal
        let icons: [FontAwesome] = [.Columns, .Eye, .Stethoscope]
        let defaultSize = CGSize(width: 30, height: 30)
        for idx in 0..<tabBarItems.count {
            tabBarItems[idx].image = UIImage.fontAwesomeIconWithName(icons[idx], textColor: .black, size: defaultSize)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "embedTabBarCPU":
                // the storyboard is hooking up the TabBar
                tabBar = segue.destination as! UITabBarController
                customizeTabBarImages((tabBar.tabBar.items)! as [UITabBarItem])
                
                // initialize all the tabBar's viewControllers by looping through the viewControllers...
                if tabBar.viewControllers != nil {
                    for idx in tabBar.viewControllers! {
                        // and accessing the `view` of each
                        let _ = idx.view
                        // print("accessed view num \(idx)")
                    }
                }
                
                // now we can assign all the elements of tabVCs
                tabVCs.split = tabBar.viewControllers?[0] as? CPUSplitController
                tabVCs.visual = tabBar.viewControllers?[1] as? CPUVisualController

                tabVCs.trace = tabBar.viewControllers?[2] as? CPUTraceController
                
            default:
                break
                
            }
        }
    }
    
    
    
    // MARK: IBOutlets
    @IBOutlet var runBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.runBtn, nameOfIcon: .Play, ofSize: 20)
        }
    }
    @IBOutlet var debugBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.debugBtn, nameOfIcon: .Bug, ofSize: 20)
        }
    }
    @IBOutlet weak var busBtn: UIBarButtonItem!
    
    @IBOutlet var fontBtn: UIBarButtonItem!
    
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
    // MARK: IBActions

    @IBAction func runBtnPressed(_ sender: UIBarButtonItem) {
        if cpuAssembler.microAssemble() {
            
        }
    }
    
    @IBAction func debugBtnPressed(_ sender: UIBarButtonItem) {
        // Assemble, output errors if necessary
        // Start single-step
    }
    
}
