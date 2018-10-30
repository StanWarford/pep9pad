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
    
    
    
    // MARK: - View Controller Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        // note that we don't do anything with the view, we just have to access it
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
    
    
    
    // MARK: - Methods -
    func switchToBus(_ ofSize: CPUBusSize) {
        if ofSize != cpuView.busSize {
            // change the global instance
            changeBusInstance(toSize: ofSize)
            tabVCs.split?.busSizeChanged()
            tabVCs.visual?.busSizeChanged()
            tabVCs.trace?.busSizeChanged()
        } else {
            print("no CPU change necessary")
        }
    }
    
    
    
    // MARK: - Conformance to UITabBarDelegate -
    
    func customizeTabBarImages(_ tabBarItems: [UITabBarItem]) {
        // could also work: .Tasks, .TH List, .Server, .Dashboard, .FileText, .SiteMap, .Binoculars, .HDD, .Map, .Tachometer, .Table, .Stethoscope, .Terminal
        let icons: [FontAwesome] = [.columns, .eye, .stethoscope]
        let defaultSize = CGSize(width: 30, height: 30)
        for idx in 0..<tabBarItems.count {
            tabBarItems[idx].image = UIImage.fontAwesomeIcon(name: icons[idx], textColor: .black, size: defaultSize)
        }
    }
    
    
    
    // MARK: - IBOutlets -
    
    /// Convenience function that sets the `title` property of a `UIBarButtonItem` to a `FontAwesome` icon.
    func setButtonIcon(forBarBtnItem btn: UIBarButtonItem, nameOfIcon: FontAwesome, ofSize: CGFloat) {
        let attrs = [NSAttributedStringKey.font: UIFont.fontAwesome(ofSize: ofSize)] as Dictionary!
        btn.setTitleTextAttributes(attrs, for: .normal)
        btn.title = String.fontAwesomeIcon(name: nameOfIcon)
    }
    
    @IBOutlet var runBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.runBtn, nameOfIcon: .play, ofSize: 20)
        }
    }
    @IBOutlet var debugBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.debugBtn, nameOfIcon: .bug, ofSize: 20)
        }
    }
    @IBOutlet weak var busBtn: UIBarButtonItem!
    
    @IBOutlet var fontBtn: UIBarButtonItem!
    
    @IBOutlet var calcBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.calcBtn, nameOfIcon: .calculator, ofSize: 20)
        }
    }
    @IBOutlet var settingsBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.settingsBtn, nameOfIcon: .cog, ofSize: 20)
        }
    }
    
    @IBOutlet var actionBtn: UIBarButtonItem!
    
    
    
    
    // MARK: - IBActions -

    @IBAction func runBtnPressed(_ sender: UIBarButtonItem) {
//        if cpuAssembler.microAssemble() {
//            
//        }
    }
    
    @IBAction func debugBtnPressed(_ sender: UIBarButtonItem) {
        // Assemble, output errors if necessary
        // Start single-step
        
        
//        CPU1ByteRenderer.registerBankColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.bitsBoxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aLUColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.arrowBlack = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aLUstrokeblack = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.labelBlack = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aLUvalgrey = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mWhite = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.loadCkArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.bArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.bBusPipeColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aBusPipeColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cBusPipeColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mARCkArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mDRCkArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aMUXArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mDRMuxArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cMuxArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aMuxComboColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aLULArrowsColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cBitArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.vBitArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.zBitArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.nBitArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.memWriteArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.memReadArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cSMuxInArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.sCkArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cCkArrowInColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.vCkArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.andZArrowInColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.nCkArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.andZArrowOutColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mARBColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mARAColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mARArrowColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.systemBusColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.memWriteColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mDRCktoAMuxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.mDRMuxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.bustoMDRMuxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.aLUtoCMuxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.cSMuxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.bitstoCMuxColor = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        CPU1ByteRenderer.checkBoxFill = UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.000)
//        
//        cpuView.setNeedsDisplay()
        
    }
    
    
    @IBAction func busBtnPressed(_ sender: UIBarButtonItem) {
        
        var alertController: UIAlertController
        
        if cpuView.busSize == .oneByte {
            alertController = UIAlertController(title: nil, message: "You're using the one-byte bus.", preferredStyle: .actionSheet)

            let twoByteAction = UIAlertAction(title: "Switch to two-byte bus", style: .default) { (action) in
                self.switchToBus(.twoByte)
            }
            alertController.addAction(twoByteAction)
        } else {
            alertController = UIAlertController(title: nil, message: "You're using the two-byte bus.", preferredStyle: .actionSheet)
            let oneByteAction = UIAlertAction(title: "Switch to one-byte bus", style: .default) { (action) in
                self.switchToBus(.oneByte)
            }
            alertController.addAction(oneByteAction)

        }
        
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)


    }
    
    @IBAction func fontBtnPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func calcBtnPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func settingsBtnPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func actionBtnPressed(_ sender: UIBarButtonItem) {
    }
    
}
