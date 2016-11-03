//
//  ASMDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/4/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift

/// A top-level controller that contains a `UITabBar` and serves as its delegate.
/// This controller also handles all `UIBarButtonItem`s along the `UINavigationBar`.  
class ASM_DetailViewController: UIViewController, UITabBarDelegate {
    
    internal var master: ASM_MasterViewController!
    internal var sourceVC: ASM_SourceViewController!
    internal var tabController: UITabBarController!
    
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get ref to master and save to local `master` property
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! ASM_MasterViewController
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
        // could also work: .Tasks, .TH List, .Server, .Dashboard, .FileText, .SiteMap, .Binoculars, .HDD, .Map, .Tachometer, .Table, .Stethoscope, .Terminal
        let icons: [FontAwesome] = [.FileText, .Code, .List, .Reorder, .Stethoscope]
        let defaultSize = CGSize(width: 30, height: 30)
        for idx in 0..<tabBarItems.count {
            tabBarItems[idx].image = UIImage.fontAwesomeIconWithName(icons[idx], textColor: .black, size: defaultSize)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "embedTagBar":
                // the storyboard is hooking up the ASMTabBar
                print("Embedding the tab bar")
                tabController = segue.destination as! UITabBarController
                customizeTabBarImages((tabController.tabBar.items)! as [UITabBarItem])

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
            self.assembleSource()
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
        
        let newAction = UIAlertAction(title: "New Project", style: .default) { (action) in
            //TODO: Implement newAction
            self.newProject()
        }
        newAction.isEnabled = (editorModel.fsState != .Blank)
        alertController.addAction(newAction)

        let openAction = UIAlertAction(title: "Open Project", style: .default) { (action) in
            self.openProject()
        }
        openAction.isEnabled = true
        alertController.addAction(openAction)
        
        let saveAction = UIAlertAction(title: "Save Project", style: .default) { (action) in
            self.saveProject()
        }
        saveAction.isEnabled = (editorModel.fsState == .UnsavedUnnamed) || (editorModel.fsState == .UnsavedNamed)
        alertController.addAction(saveAction)
        
        let shareAction = UIAlertAction(title: "Share Project", style: .default) { (action) in
            self.shareProject()
        }
        shareAction.isEnabled = (editorModel.fsState != .Blank)
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
    
    
    
    
    // MARK: - Methods
    
    
    func newProject() {
        switch editorModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently

            let alertController = UIAlertController(title: "Want to save?", message: "Would you like to save your changes to the current project?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                // TODO: Handle save
                // TODO: Handle new project creation
                print("saving changes and creating a new project")
                editorModel.fsState = .Blank
            }
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                // TODO: Handle new project creation
                print("discarding changes and creating a new project")
                editorModel.fsState = .Blank
            }
            alertController.addAction(noAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // Don't do anything
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
            
        case .UnsavedUnnamed:
            // project has never been saved
            
            let alertController = UIAlertController(title: "Save first?", message: "This project has never been saved.  Would you like to save it now?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                // user needs to name the project
                let alertController = UIAlertController(title: "Name your project", message: "Please give this project a name.", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: nil)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // user would like to cancel this project creation
                }
                alertController.addAction(cancelAction)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // TODO: Save the current project under the given name
                    // TODO: Handle creation of new project
                    print("saving current project with the given name and creating a new project")
                    editorModel.fsState = .Blank
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
            
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                // user wants to throw this unsaved project away and start anew
                // TODO: Handle new project creation
                print("destroying current project and creating a new project")
                editorModel.fsState = .Blank
            }
            alertController.addAction(noAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user wants to cancel, so don't do anything
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
        case .SavedNamed:
            // project is already saved
            // TODO: Handle new project creation
            print("creating new project")
        case .Blank:
            // greyed-out buttons should've prevented you from getting here
            assert(false, "FSM for FS was not implemented correctly in code.")
        }
    }
    
    func openProject() {
        switch editorModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently
            let alertController = UIAlertController(title: "Want to save?", message: "Would you like to save your changes to the current project?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                // TODO: Handle save
                // TODO: Handle open project
                print("saving changes and opening a preexisting project")
                editorModel.fsState = .SavedNamed
            }
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                // TODO: Handle open project
                print("discarding changes and opening a preexisting project")
                editorModel.fsState = .SavedNamed
            }
            alertController.addAction(noAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // Don't do anything
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        case .UnsavedUnnamed:
            // project has never been saved
            let alertController = UIAlertController(title: "Save first?", message: "This project has never been saved.  Would you like to save it now?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                // user needs to name the project
                let alertController = UIAlertController(title: "Name your project", message: "Please give this project a name.", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: nil)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // user would like to cancel this project creation
                }
                alertController.addAction(cancelAction)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // TODO: Save the current project under the given name
                    // TODO: Handle open project
                    print("saving current project with the given name and opening a preexisting project")
                    editorModel.fsState = .SavedNamed
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
            
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                // user wants to throw this unsaved project away and open a preexisting project
                // TODO: Handle open project
                print("destroying this project and opening a preexisting project")
                editorModel.fsState = .SavedNamed
            }
            alertController.addAction(noAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user wants to cancel, so don't do anything
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)

        case .SavedNamed, .Blank:
            // these go together, as in both instances there is nothing (more) to save
            // TODO: Handle open project
            print("opening a preexisting project")
            break
        }
        
        let fsStoryboard = UIStoryboard.init(name: "FileSystem", bundle: Bundle.main)
        self.present(fsStoryboard.instantiateInitialViewController()!, animated: true, completion: nil)
    }
    
    func saveProject() {
        switch editorModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently
            // Rather than present an alertController here, I say we just update the fs.  
            // Having an "are you sure?" message seems redundant for something as innocuous as a save.
            if updateProjectInFS(named: editorModel.name, source: editorModel.source, object: editorModel.object, listing: editorModel.listing) {
                editorModel.fsState = .SavedNamed
                print("updated fs with latest version of project")
            } else {
                print("could not update fs with latest version of project")
            }

        case .UnsavedUnnamed:
            // project has never been saved
            // Similar to above, I don't think we need an "are you sure?" message for saving the current project as a new project.
            
            let alertController = UIAlertController(title: "Name your project", message: "Please give this project a name.", preferredStyle: .alert)
            
            alertController.addTextField(configurationHandler: nil)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user would like to cancel this project creation
            }
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // TODO: Save the current project under the given name
                print("saving current project with the given name")
                editorModel.fsState = .SavedNamed
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            
        case .SavedNamed, .Blank:
            // greyed-out buttons should've prevented you from getting here
            assert(false, "FSM for FS was not implemented correctly in code.")
        }
    }
    
    func shareProject() {
        
    }
    
    
    
    func load(_ text: String, ofType: PepFileType) {
        // TODO: Figure out whether the user has unsaved work and ask accordingly
        switch ofType {
        case .pep:
            // load into SourceViewController
            tabController.selectedIndex = 0
            (tabController.selectedViewController as? ASM_SourceViewController)?.textView.setText(text)
            
            
        case .pepo, .peph:
            // load into ObjectViewController
            tabController.selectedIndex = 1
            (tabController.selectedViewController as? ASM_ObjectViewController)?.textView.setText(text)

        default:
            break
        }
    }
    
    
    /// A top-level function that is called whenever the user taps the 'Assemble Source' button.  This function is responsible for calling the `assemble()` method in the `sourceVC`.  If this call is successful it calls methods in all relevant viewcontrollers.
    func assembleSource() -> Bool {
        
        // PLACEHOLDER
        return true

//        burnCount = 0
//        if sourceVC.assemble() {
//            // check for .BURN
//            if burnCount > 0 {
//                let error = ";ERROR: .BURN not allowed in program unless installing OS."
//                sourceVC.appendMessageAt(0, error)
//                listingVC.clear()
//                objectVC.clear()
//                traceVC.clear()
//                // TODO: make source code tab visible
//                return false
//            }
//            
//            // no .BURN, proceed with assemble
//            objectVC.setObjectCode(sourceVC.getObjectCode())
//            listingVC.setListing(sourceVC.getListing())
//            traceVC.setListing(sourceVC.getListingForTrace())
//            traceVC.setMemoryTrace()
//            listingVC.showListing()
//            
//            // TODO: update current object and listing files
//            // TODO: format from listing
//            return true
//            
//        } else {
//            listingVC.clear()
//            objectVC.clear()
//            traceVC.clear()
//            // TODO: make source code tab visible
//            return false
//        
//        }
    }
    
    
    
    
}
