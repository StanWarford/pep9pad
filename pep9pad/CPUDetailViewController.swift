//
//  CPUDetailViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CPUDetailViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Convenience function that sets the `title` property of a `UIBarButtonItem` to a `FontAwesome` icon.
    func setButtonIcon(forBarBtnItem btn: UIBarButtonItem, nameOfIcon: FontAwesome, ofSize: CGFloat) {
        let attrs = [NSFontAttributeName: UIFont.fontAwesomeOfSize(ofSize)] as Dictionary!
        btn.setTitleTextAttributes(attrs, for: .normal)
        btn.title = String.fontAwesomeIconWithName(nameOfIcon)
    }

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

}
