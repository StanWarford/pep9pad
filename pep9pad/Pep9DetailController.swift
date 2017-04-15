//
//  Pep9DetailController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MessageUI
import PKHUD


/// A top-level controller that contains a `UITabBar` and serves as its delegate.
/// This controller also handles all `UIBarButtonItem`s along the `UINavigationBar`.

/// Regular Expressions
let rxRemoveError = try! NSRegularExpression(pattern: ";ERROR:[\\s].*$")

class Pep9DetailController: UIViewController, UITabBarDelegate {

    internal var master: Pep9MasterController!
    internal var tabBar: UITabBarController!
    // must initialize this, otherwise we get a runtime error
    internal var tabVCs: Pep9TabBarVCs = (nil, nil, nil, nil)
    
    internal let byteCalc = ByteCalc()
    internal let fontMenu = FontMenu()
    internal let debugMenu = DebugMenu()
    internal let mailer = Pep9Mailer()
    internal let redefineMnemonics = RedefineMnemonics()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get reference to master by going through the navigation controller
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! Pep9MasterController
        // customize heads up display
        HUD.dimsBackground = false
        HUD.flash(.labeledSuccess(title: "Installed OS", subtitle: ""), delay: 0.5)
        setState(.unBuilt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Conformance to UITabBarDelegate
    
    func customizeTabBarImages(_ tabBarItems: [UITabBarItem]) {
        // could also work: .Tasks, .TH List, .Server, .Dashboard, .FileText, .SiteMap, .Binoculars, .HDD, .Map, .Tachometer, .Table, .Stethoscope, .Terminal
        let icons: [FontAwesome] = [.FileText, .Code, .List, .Reorder]
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
                // print("Embedding the tab bar")
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
                tabVCs.source = tabBar.viewControllers?[0] as? SourceController
                tabVCs.object = tabBar.viewControllers?[1] as? ObjectController
                tabVCs.listing = tabBar.viewControllers?[2] as? ListingController
                tabVCs.trace = tabBar.viewControllers?[3] as? TraceController
                
            default:
                break
                
            }
        }
    }
    
    
    //MARK: Install New OS Action Helper
    // TODO: FINISH THIS FUNC
    func installNewOSActionHelper(error: String) {
        projectModel.appendMessageInSource(atLine: 0, message: error)
        projectModel.listingStr = ""
        projectModel.objectStr = ""
        // TODO: listingTrace
        print("Assembly failed")
    }
    
    
    func setObjectCode(objectCode: [Int]) {
        // TODO: implement setObjectCode
    }
    
    
    // MARK: - IBOutlets
    
    
    
    
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
    
    @IBOutlet var fontBtn: UIBarButtonItem!
    
    @IBOutlet var actionBtn: UIBarButtonItem!
    
    
    var stepBtn: UIBarButtonItem!
    var resBtn: UIBarButtonItem!
    
    
    //MARK: - IBActions
    
    /// Corresponds to the "play button". Assembles, loads, and executes.
    @IBAction func runBtnPressed(_ sender: UIBarButtonItem) {
    
        if assembler.assemble() {
            loadObject()
            execute()
        }
    }
    
    @IBAction func debugBtnPressed(_ sender: UIBarButtonItem) {
        // what we do here depends on the state of the app
        // if debugging, this is a stop icon, and a press means stop debugging
        if sender.title == String.fontAwesomeIconWithName(.Stop) {
            stopDebugging()
        } else {
            let menu = self.debugMenu.makeAlert(barButton: debugBtn, detail: self)
            self.present(menu, animated: true, completion: nil)
        }
    }
    
    @IBAction func buildBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let assembleSourceAction = UIAlertAction(title: "Assemble Source", style: .default) { (action) in
            self.assembleSource()
        }
        alertController.addAction(assembleSourceAction)
        
        let loadObjectAction = UIAlertAction(title: "Load Object", style: .default) { (action) in
            self.loadObject()
        }
        alertController.addAction(loadObjectAction)
        
        let executeAction = UIAlertAction(title: "Execute", style: .default) { (action) in
            self.execute()
        }
        alertController.addAction(executeAction)
        
        let runObjectAction = UIAlertAction(title: "Run Object", style: .default) { (action) in
            self.execute()
        }
        alertController.addAction(runObjectAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionBtnPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newAction = UIAlertAction(title: "New Project", style: .default) { (action) in
            self.newProjectBtnPressed()
        }
        newAction.isEnabled = (projectModel.fsState != .Blank)
        alertController.addAction(newAction)
        
        let openAction = UIAlertAction(title: "Open Project", style: .default) { (action) in
            self.openProjectBtnPressed()
        }
        openAction.isEnabled = true
        alertController.addAction(openAction)
        
        let saveAction = UIAlertAction(title: "Save Project", style: .default) { (action) in
            self.saveProjectBtnPressed()
        }
        saveAction.isEnabled = (projectModel.fsState == .UnsavedUnnamed) || (projectModel.fsState == .UnsavedNamed)
        alertController.addAction(saveAction)
        
        let shareAction = UIAlertAction(title: "Share Project", style: .default) { (action) in
            self.shareProjectBtnPressed(sender: self.actionBtn)
        }
        shareAction.isEnabled = (projectModel.fsState != .Blank)
        alertController.addAction(shareAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func fontBtnPressed(_ sender: UIBarButtonItem) {
        let fontMenu = self.fontMenu.makeAlert(barButton: sender)
        self.present(fontMenu, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func calcBtnPressed(_ sender: UIBarButtonItem) {
        let calcAlert = byteCalc.makeAlert()
        self.present(calcAlert, animated: true, completion: nil)
        
    }
    

    @IBAction func settingsBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let formatFromListingAction = UIAlertAction(title: "Format From Listing", style: .default) { (action) in
            let assemblerListingList: [String] = assembler.getAssemblerListing();
            let regex = try! NSRegularExpression(pattern: "^.............", options: NSRegularExpression.Options.caseInsensitive)
            
            for str in assemblerListingList {
                regex.replaceMatches(in: NSMutableString(string: str), options: NSRegularExpression.MatchingOptions.reportCompletion, range: str.fullRange(), withTemplate: "")
            }
            
            let newStr = assemblerListingList.joined(separator: "\n")
        }
        alertController.addAction(formatFromListingAction)
        
        let removeErrorMsgsAction = UIAlertAction(title: "Remove Error Messages", style: .default) { (action) in
            projectModel.removeErrorMessages()
            self.updateEditorsFromProjectModel()
        }
        alertController.addAction(removeErrorMsgsAction)
        
        let clearMemAction = UIAlertAction(title: "Clear Memory", style: .default) { (action) in
            for i in 0 ..< maps.romStartAddress {
                machine.mem[i] = 0
            }
            self.master.cpu.clearCpu()
            self.master.io.memoryView.refresh()
        }
        alertController.addAction(clearMemAction)
        
        let redefineMnemonicsAction = UIAlertAction(title: "Redefine Mnemonics", style: .default) { (action) in
            let redefineMnemon = self.redefineMnemonics.makeAlert()
            self.present(redefineMnemon, animated: true, completion: nil)

        }
        alertController.addAction(redefineMnemonicsAction)
        
        let installNewOSAction = UIAlertAction(title: "Install New OS", style: .default) { (action) in
            maps.burnCount = 0
            maps.memAddrssToAssemblerListing = maps.memAddrssToAssemblerListingOS
            maps.listingRowChecked =  maps.listingRowCheckedOS
            if assembler.assemble() {
                if !(maps.symbolTable["charIn"] != nil) {
                    self.installNewOSActionHelper(error: ";ERROR: charIn required to install OS.")
                }
                else if !(maps.symbolTable["charOut"] != nil) {
                    self.installNewOSActionHelper(error: ";ERROR: charOut required to install OS.")
                }
                else if maps.burnCount == 0 {
                    self.installNewOSActionHelper(error: ";ERROR: .BURN required to install OS.")
                }
                else if maps.burnCount > 1 {
                    self.installNewOSActionHelper(error: ";ERROR: Program required to install OS.")
                }
                else {
                    let addressDelta: Int = maps.dotBurnArgument - maps.byteCount + 1
                    let mapIterator = maps.symbolTable
                    for var i in mapIterator {
                        if maps.adjustSymbolValueForBurn[i.key]! {
                            i.value = i.value + addressDelta
                        }
                    }
                    assembler.adjustSourceCode(addressDelta: addressDelta)
                    maps.romStartAddress += addressDelta
                    self.setObjectCode(objectCode: assembler.getObjectCode())
                    assembler.listing = assembler.getAssemblerListing()
                    assembler.setListingTrace(listingTraceList: assembler.getAssemblerListing())
                    assembler.loadOSIntoMem()
                    self.master.io.memoryView.refresh()
                    // MARK: ui bar subject to change
                    print("Assembly succeeded, OS installed")
                }
            }
            else {
                projectModel.listingStr = ""
                projectModel.objectStr = ""
                assembler.setListingTrace(listingTraceList: [""])
                // MARK: ui bar subject to change
                print("Assembly failed")
            }
        }
        alertController.addAction(installNewOSAction)
        
        let reinstallDefaultOSAction = UIAlertAction(title: "Reinstall Default OS", style: .default) { (action) in
            maps.memAddrssToAssemblerListing = maps.memAddrssToAssemblerListingOS
            maps.listingRowChecked = maps.listingRowCheckedOS
            if assembler.installDefaultOS() {
                assembler.getAssemblerListing()
                //assembler.setListingTrace(listingTraceList: assembler.getAssemblerListing())
                print("OS Installed")
                print(assembler.getReadableObjectCode())
            } else {
                print("OS assembly failed")
            }
        }
        alertController.addAction(reinstallDefaultOSAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Methods
    
    
    func newProjectBtnPressed() {
        switch projectModel.fsState {
        case .UnsavedNamed:
            // project was edited
            
            let alertController = UIAlertController(title: "Want to save?", message: "Would you like to save your changes to the current project?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                print("saving changes and creating a new project")
                projectModel.saveExistingProject()
                projectModel.newBlankProject()
                self.updateEditorsFromProjectModel()
                
            }
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                print("discarding changes and creating a new project")
                projectModel.newBlankProject()
                self.updateEditorsFromProjectModel()
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
                    let name = (alertController.textFields?.first?.text)!
                    if p9FileSystem.validNameForProject(name: name) {
                        projectModel.saveAsNewProject(withName: name)
                        projectModel.newBlankProject()
                        self.updateEditorsFromProjectModel()
                        print("saving current project with the given name and creating a new project")
                    } else {
                        print("invalid (non-unique or too short) name for project, giving up save")
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
            
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                // user wants to throw this unsaved project away and start anew
                print("destroying current project and creating a new project")
                projectModel.newBlankProject()
                self.updateEditorsFromProjectModel()
            }
            alertController.addAction(noAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user wants to cancel, so don't do anything
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
        case .SavedNamed:
            // project is already saved
            print("creating new project")
            projectModel.newBlankProject()
            self.updateEditorsFromProjectModel()
        case .Blank:
            // greyed-out buttons should've prevented you from getting here
            assert(false, "FSM for FS was not implemented correctly in code.")
        }
    }
    
    
    
    
    
    
    
    
    func openProjectBtnPressed() {
        switch projectModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently
            let alertController = UIAlertController(title: "Want to save?", message: "Would you like to save your changes to the current project?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                // save changes and present fs
                print("saving changes and opening a preexisting project")
                projectModel.saveExistingProject()
                //self.updateEditorsFromProjectModel()
                self.presentFileSystem()
            }
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                // discard changes and present fs
                print("discarding changes and opening a preexisting project")
                //self.updateEditorsFromProjectModel()
                self.presentFileSystem()
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
                    print("saving current project with the given name and opening a preexisting project")
                    let name = (alertController.textFields?.first?.text)!
                    if p9FileSystem.validNameForProject(name: name) {
                        projectModel.saveAsNewProject(withName: name)
                        self.updateEditorsFromProjectModel()
                        self.presentFileSystem()
                    } else {
                        print("invalid (non-unique or too short) name for project, giving up save")
                        self.presentFileSystem()
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
            
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                print("destroying this project and opening a preexisting project")
                self.presentFileSystem()
                
            }
            alertController.addAction(noAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user wants to cancel, so don't do anything
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
        case .SavedNamed, .Blank:
            // these go together, as in both instances there is nothing (more) to save
            print("opening a preexisting project")
            self.presentFileSystem()
        }
        
    }
    
    
    func presentFileSystem() {
        let vc = UIStoryboard(name: "FileSystem", bundle: Bundle.main).instantiateInitialViewController()
        self.present(vc!, animated: true) {
            if let spvc = vc as! UISplitViewController? {
                let nav = spvc.viewControllers[0] as! UINavigationController
                let fs = nav.viewControllers[0] as! FSMasterController
                fs.setup(asmDetailVC: self)
            }
        }
    }
    
    func saveProjectBtnPressed() {
        switch projectModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently
            // Rather than present an alertController here, I say we just update the fs.
            // Having an "are you sure?" message seems redundant for something as innocuous as a save.
            projectModel.saveExistingProject()
            
        case .UnsavedUnnamed:
            // project has never been saved
            // Similar to above, I don't think we need an "are you sure?" message for saving the current project as a new project.
            
            // user needs to name the project
            let alertController = UIAlertController(title: "Name your project", message: "Please give this project a name.", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user would like to cancel this project creation
            }
            alertController.addAction(cancelAction)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("saving current project with the given name and opening a preexisting project")
                let name = (alertController.textFields?.first?.text)!
                if p9FileSystem.validNameForProject(name: name) {
                    projectModel.saveAsNewProject(withName: name)
                    self.updateEditorsFromProjectModel()
                } else {
                    print("invalid (non-unique or too short) name for project, giving up save")
                }
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            
            
        case .SavedNamed, .Blank:
            // greyed-out buttons should've prevented you from getting here
            assert(false, "FSM for FS was not implemented correctly in code.")
        }
    }
    
    func shareProjectBtnPressed(sender: AnyObject) {
        let mailController = mailer.makeAlert()
        self.present(mailController, animated: true, completion: nil)
    }
    
    /// Try to load the given example.  Depending on `self.fsState`, this function may present the user with options (e.g. if the user has never saved the current project) before loading the given example.  If the user chooses to cancel this save operation, the function returns false.
    func attemptToLoadExample(text: String, ofType: PepFileType) -> Bool {
        var shouldLoad: Bool = true
        switch projectModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently
            // rather than present an alertController here, I say we just update the fs automatically
            projectModel.saveExistingProject()
        case .UnsavedUnnamed:
            // project has never been saved
            
            let alertController = UIAlertController(title: "Save first?", message: "This project has never been saved.  Would you like to save it now?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                // user needs to name the project
                let alertController = UIAlertController(title: "Name your project", message: "Please give this project a name.", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: nil)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // user would like to cancel this project creation
                    // may be incorrect to set shouldLoad to false
                    // TODO: figure out the behavior of the second-order `Cancel` option.
                    shouldLoad = false
                }
                alertController.addAction(cancelAction)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("saving current project with the given name and loading the given example")
                    let name = (alertController.textFields?.first?.text)!
                    if p9FileSystem.validNameForProject(name: name) {
                        projectModel.saveAsNewProject(withName: name)
                    } else {
                        print("invalid (non-unique or too short) name for project, giving up save")
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
            
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
                print("destroying this project and loading the given example")
            }
            alertController.addAction(noAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // user wants to cancel the example load
                shouldLoad = false
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            
            
        case .SavedNamed, .Blank:
            // nothing more to do, proceed with loading example
            break
        }
        
        if shouldLoad {
            projectModel.loadExample(text: text, ofType: ofType)
            updateEditorsFromProjectModel()
            switchToTab(atIndex: (ofType == .pep ? 0 : 1))
            setState(.unBuilt)
        }
        
        return shouldLoad
    }
    
    /// Switches the tabBar to the appropriate index.
    func switchToTab(atIndex i: Int) {
        tabBar.selectedIndex = i
    }
    
    
    func updateEditorsFromProjectModel() {
        tabVCs.source?.pullFromProjectModel()
        tabVCs.object?.pullFromProjectModel()
        tabVCs.listing?.pullFromProjectModel()
    }
    
    /// Called whenever the user taps the 'Assemble Source' button.  This function...
    
    /// * assembles the source code by calling `assembler.assemble()`
    ///   * the model parses the asmb and populates the `assembler.object` and `assembler.listing` fields
    ///   * the model then calls its `updateProjectModel()` method which sets `projectModel.sourceStr`, `.listingStr`, and `.objectStr`
    /// * this function asks the source, object, and listing viewcontrollers to pull changes from projectModel.
    func assembleSource() {
        if assembler.assemble() && maps.burnCount == 0 {
            // no .BURN directive found, continue with assembly
            projectModel.objectStr = assembler.getReadableObjectCode()
            projectModel.listingStr = assembler.getReadableListing()
            // TODO: update trace stuff
            HUD.flash(.labeledSuccess(title: "Assembled", subtitle: ""), delay: 1.0)
            setState(.built)
            
        } else if maps.burnCount > 0 {
            // .BURN directive found, but not installing OS
            let error = ";ERROR: .BURN not allowed in program unless installing OS."
            projectModel.appendMessageInSource(atLine: 0, message: error)
            projectModel.objectStr.removeAll()
            projectModel.listingStr.removeAll()
            switchToTab(atIndex: 0) // go to source editor
            HUD.flash(.labeledError(title: "Error", subtitle: error), delay: 1.5)
            setState(.unBuilt)
            
        } else {
            // the assembly failed for another reason
            let error = assembler.assemblyFailureMessage.replacingOccurrences(of: ";ERROR: ", with: "")
            projectModel.objectStr.removeAll()
            projectModel.listingStr.removeAll()
            switchToTab(atIndex: 0) // go to source editor
            HUD.flash(.labeledError(title: "Error", subtitle: error), delay: 1.5)
            setState(.unBuilt)

        }
        // no matter what, update the editors from the projectModel
        updateEditorsFromProjectModel()
    }
    
    
    
    /// Called whenever the user taps the 'Load Object' button.  This function...
    
    /// * loads assembler.object into memory, if it exists
    /// * refreshes the memory dump
    
    func loadObject() -> Bool {
        var obj = assembler.getObjectCode()
        for i in 0..<obj.count {
            machine.mem[i] = obj[i]
        }
        master.io.memoryView.refresh()
        
        return true
    }
    
    
    /// Executes whatever's currently stored in the machine.
    /// Begins at beginning of memory and follows the PC from there on out.
    /// Iteratively asks the `machine` to perform a `vonNeumannStep`.
    func execute() {
        master.cpu.clearCpu()
        // 11 is the offset from the last byte of the OS to the stack pointer
        // TODO: just make this a computed property in the machine
        machine.stackPointer = machine.readWord(maps.dotBurnArgument-11)
        // reset the program counter to the beginning of memory
        machine.programCounter = 0
        // set debug state
        machine.isTrapped = false
        // set source and object to read only, may not be necessary
        if master.io.currentMode == .batchIO {
            master.io.batchOutputTextView.text.removeAll()
            if var input = master.io.batchInputTextView.text {
                if !input.hasSuffix("\n") {
                    input.append("\n")
                }
                machine.inputBuffer = input
            }

            var errorStr = ""
            while true {
                if machine.vonNeumannStep(errorString: &errorStr) {
                    // emit vonNeumannStepped
                    if machine.outputBuffer.length > 0 {
                        master.io.appendOutput(machine.outputBuffer)
                        machine.outputBuffer = ""
                    }
                } else {
                    // error ocurred in VonNeumann step
                    HUD.flash(.labeledError(title: "Simulation Failed", subtitle: errorStr), delay: 0.5)
                    master.cpu.update()
                    stopDebugging()
                    machine.isSimulating = false
                    return
                }
                
                if maps.decodeMnemonic[machine.instructionSpecifier] == .STOP {
                    master.cpu.update()
                    stopDebugging()
                    machine.isSimulating = false
                    return
                }
                
                if machine.shouldHalt {
                    master.cpu.update()
                    // emit updateSimulationView
                    machine.isSimulating = false
                    return
                }
            }

        } else if master.io.currentMode == .terminalIO {
            machine.inputBuffer = ""
            master.io.terminalTextView.text.removeAll()
            
            machine.isSimulating = true
            // set waiting
            machine.shouldHalt = false
            var errorStr = ""
            while true {
                if machine.inputBuffer.isEmpty && machine.willAccessCharIn() {
                    // waiting for user input
                    master.cpu.update()
                    setState(.waitingForInput)
                    machine.isSimulating = false
                    return
                } else {
                    if machine.vonNeumannStep(errorString: &errorStr) {
                        // emit vonNeumannStepped
                        if machine.outputBuffer.length > 0 {
                            master.io.appendOutput(machine.outputBuffer)
                            machine.outputBuffer = ""
                        }
                    } else {
                        // error ocurred in VonNeumann step
                        HUD.flash(.labeledError(title: "Simulation Failed", subtitle: errorStr), delay: 0.5)
                        master.cpu.update()
                        stopDebugging()
                        machine.isSimulating = false
                        return
                    }
                    
                    if maps.decodeMnemonic[machine.instructionSpecifier] == .STOP {
                        master.cpu.update()
                        stopDebugging()
                        machine.isSimulating = false
                        return
                    }
                    
                    if machine.shouldHalt {
                        master.cpu.update()
                        // emit updateSimulationView
                        machine.isSimulating = false
                        return
                    }

                }
            }
            
            
        } else {
            // the memory dump is what's visible, so switch to batch and try again
            master.io.setMode(to: .batchIO)
            execute() // note: recursive call
        }
    }
    
    
    func stopDebugging() {
        machine.interrupt()
        master.cpu.update()
        // update trace
        switchToTab(atIndex: 3)
        // TODO: this is not totally safe but works for now
        self.navigationItem.leftBarButtonItems?.removeLast(2)
        // change icon back to a bug
        setButtonIcon(forBarBtnItem: debugBtn, nameOfIcon: .Bug, ofSize: 20)
        setState(.stopDebugging)
        

    }
    
    
    func singleStep() {
        
        machine.isSimulating = true
        machine.shouldHalt = false
        var errorStr = ""
        machine.trapLookahead()
        if master.io.currentMode == .batchIO {
            if machine.isTrapped && !machine.shouldTraceTraps {
                // not tracing traps
                while machine.isTrapped {
                    machine.trapLookahead()
                    if machine.vonNeumannStep(errorString: &errorStr) {
                        // emit vonNeumannStepped
                        if machine.outputBuffer.length > 0 {
                            master.io.appendOutput(machine.outputBuffer)
                            machine.outputBuffer = ""
                        }
                    } else {
                        // error ocurred in VonNeumann step
                        HUD.flash(.labeledError(title: "Simulation Failed", subtitle: errorStr), delay: 0.5)
                        master.cpu.update()
                        stopDebugging()
                        machine.isSimulating = false
                        return
                    }
                    
                    if maps.decodeMnemonic[machine.instructionSpecifier] == .STOP {
                        master.cpu.update()
                        stopDebugging()
                        machine.isSimulating = false
                        return
                    }
                    
                    if machine.shouldHalt {
                        master.cpu.update()
                        // emit updateSimulationView
                        machine.isSimulating = false
                        return
                    }
                }
                // refresh the cpu
                master.cpu.update()
            } else if machine.vonNeumannStep(errorString: &errorStr) {
                // we are tracing traps
                // emit vonNeumannStepped
                if machine.outputBuffer.length > 0 {
                    master.io.appendOutput(machine.outputBuffer)
                    machine.outputBuffer = ""
                }
                if maps.decodeMnemonic[machine.instructionSpecifier] != .STOP {
                    master.cpu.update()
                } else {
                    // instruction was a STOP instruction
                    machine.isSimulating = false
                    stopDebugging()
                }
            } else {
                // error ocurred in VonNeumann step
                HUD.flash(.labeledError(title: "Simulation Failed", subtitle: errorStr), delay: 0.5)
                master.cpu.update()
                stopDebugging()
                machine.isSimulating = false
                return
            }
        } else {
            // terminal i/o mode
            if machine.isTrapped && !machine.shouldTraceTraps {
                master.cpu.update()
                while machine.isTrapped {
                    machine.trapLookahead()
                    if machine.inputBuffer.isEmpty && machine.willAccessCharIn() {
                        // waiting for input from user
                        // emit waitingForinput
                        setState(.waitingForInput)
                        machine.isSimulating = false
                        return
                    } else {
                        // not waiting for input, go ahead and simulate
                        if machine.vonNeumannStep(errorString: &errorStr) {
                            // emit vonNeumannStepped
                            if machine.outputBuffer.length > 0 {
                                master.io.appendOutput(machine.outputBuffer)
                                machine.outputBuffer = ""
                            }
                        } else {
                            // error ocurred in VonNeumann step
                            HUD.flash(.labeledError(title: "Simulation Failed", subtitle: errorStr), delay: 0.5)
                            master.cpu.update()
                            stopDebugging()
                            machine.isSimulating = false
                            return
                        }
                        
                        if maps.decodeMnemonic[machine.instructionSpecifier] == .STOP {
                            master.cpu.update()
                            stopDebugging()
                            machine.isSimulating = false
                            return
                        }
                        
                        if machine.shouldHalt {
                            master.cpu.update()
                            // emit updateSimulationView
                            machine.isSimulating = false
                            return
                        }

                    }
                }
            } else if machine.inputBuffer.isEmpty && machine.willAccessCharIn() {
                setState(.waitingForInput)
                machine.isSimulating = false
            } else {
                if machine.vonNeumannStep(errorString: &errorStr) {
                    // emit vonNeumannStepped
                    if machine.outputBuffer.length > 0 {
                        master.io.appendOutput(machine.outputBuffer)
                        machine.outputBuffer = ""
                    }
                } else {
                    // error ocurred in VonNeumann step
                    HUD.flash(.labeledError(title: "Simulation Failed", subtitle: errorStr), delay: 0.5)
                    master.cpu.update()
                    stopDebugging()
                    machine.isSimulating = false
                    return
                }
                
                if maps.decodeMnemonic[machine.instructionSpecifier] != .STOP {
                    master.cpu.update()
                    stopDebugging()
                    machine.isSimulating = false
                    return
                }
                
                if machine.shouldHalt {
                    master.cpu.update()
                    stopDebugging()
                    machine.isSimulating = false
                    return
                }

            }
        }
        
    }
    
    func resumeExecution() {
        //
    }
    
    func startDebuggingSource() {
        stepBtn = UIBarButtonItem(title: "Step", style: .plain, target: self, action: #selector(self.singleStep))
        resBtn = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(self.resumeExecution))
        UIView.animate(withDuration: 0.25) {
            self.navigationItem.leftBarButtonItems?.append(self.stepBtn)
            self.navigationItem.leftBarButtonItems?.append(self.resBtn)
            // change debugBtn to be a stop symbol
            self.setButtonIcon(forBarBtnItem: self.debugBtn, nameOfIcon: .Stop, ofSize: 20)
            self.setState(.startDebugging)
        }
        switchToTab(atIndex: 3)
    }
    
    
    enum AppState {
        case startDebugging
        case stopDebugging
        case unBuilt
        case built
        case waitingForInput
    }
    
    func setState(_ forState: AppState) {
        switch forState {
        case .startDebugging:
            // disable buildBtn, actionBtn, runBtn, settingsBtn
            buildBtn.isEnabled = false
            actionBtn.isEnabled = false
            runBtn.isEnabled = false
            settingsBtn.isEnabled = false
        case .stopDebugging:
            buildBtn.isEnabled = true
            actionBtn.isEnabled = true
            runBtn.isEnabled = true
            settingsBtn.isEnabled = true
        case .unBuilt:
            debugBtn.isEnabled = false
        case .built:
            debugBtn.isEnabled = true
        case .waitingForInput:
            stepBtn.isEnabled = false
            resBtn.isEnabled = false
            
            
        }
    }
    
    
    
}
