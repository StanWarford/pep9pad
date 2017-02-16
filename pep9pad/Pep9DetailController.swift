//
//  Pep9DetailController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MessageUI

/// A typealias consisting of all elements in the ASM Tab Bar.
typealias Pep9TabBarVCs = (source: SourceController?, object: ObjectController?, listing: ListingController?, trace: TraceController?)


/// A top-level controller that contains a `UITabBar` and serves as its delegate.
/// This controller also handles all `UIBarButtonItem`s along the `UINavigationBar`.

class Pep9DetailController: UIViewController, UITabBarDelegate, MFMailComposeViewControllerDelegate {
    
    internal var master: Pep9MasterController!
    internal var tabBar: UITabBarController!
    // must initialize this, otherwise we get a runtime error
    internal var tabVCs: Pep9TabBarVCs = (nil, nil, nil, nil)
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get reference to master by going through the navigation controller
        let masternc = (self.splitViewController?.viewControllers[0])! as! UINavigationController
        self.master = masternc.viewControllers[0] as! Pep9MasterController
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
    
    
    //MARK: Mail Composition
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Subject of you mail")
        mailComposerVC.setMessageBody("Sending e-mail body", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let mailAlert = UIAlertController(title: "Error", message: "Could not send mail.", preferredStyle: .alert)
        mailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(mailAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
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
                        // print("accessed view num \(idx)")
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
    
    
    //MARK: - IBActions
    
    // Corresponds to the "play button".
    @IBAction func runBtnPressed(_ sender: UIBarButtonItem) {
        //TODO: Implement
    }
    
    @IBAction func debugBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let tempController = UIViewController()
        tempController.view.frame = CGRect(x:19.0, y:15.0, width:250.0, height:25.0)
        let trapsSwitch = UISwitch(frame: CGRect(x:0, y:0, width:25.0, height:25.0))
        let trapsLabel = UILabel(frame: CGRect(x:25, y:0, width:175.0, height:25.0))
        trapsLabel.text = "Trace Traps"
        tempController.view.addSubview(trapsSwitch)
        alertController.view.addSubview(tempController.view)
        
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
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let firstAction = UIAlertAction(title: "", style: .default) { (action) in
//        }
//        alertController.addAction(firstAction)
//        
//        
//        
//        let tempController = UIViewController()
//        tempController.view.frame = CGRect(x:19.0, y:15.0, width:250.0, height:25.0)
//        let stepperFrame = CGRect(x:0, y:0, width:250.0, height:25.0)
//        let stepper = UIStepper(frame: stepperFrame)
//        
//        tempController.view.addSubview(stepper)
//        alertController.view.addSubview(tempController.view)
//        
//        
//        let darkModeAction = UIAlertAction(title: "Turn dark mode \((!appSettings.darkModeOn).toEnglish())", style: .default) { (action) in
//            appSettings.toggleDarkMode()
//        }
//        alertController.addAction(darkModeAction)
//        
//        

        
        
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let margin:CGFloat = 8.0
        let rect = CGRect(x:margin, y:margin, width:alertController.view.bounds.size.width - margin * 4.0, height:300.0)
        let customViewForAlert = FontMenuView(frame: rect)
        alertController.view.addSubview(customViewForAlert)
        
        let somethingAction = UIAlertAction(title: "act 1", style: .default, handler: {(alert: UIAlertAction!) in print("something")})
        let cancelAction = UIAlertAction(title: "act 2", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(cancelAction)
        alertController.addAction(somethingAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
        

    }
    
    
    let byteCalc = ByteCalc()

    
    @IBAction func calcBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Byte Calculator", message: nil, preferredStyle: .alert)
        
        alertController.addTextField() { decimalField in
            self.byteCalc.decimalField = decimalField
        }
        
        alertController.addTextField() { hexField in
            self.byteCalc.hexField = hexField
        }
        
        alertController.addTextField() { binaryField in
            self.byteCalc.binaryField = binaryField
        }
        
        alertController.addTextField() { asciiField in
            self.byteCalc.asciiField = asciiField
        }
        
        alertController.addTextField() { assemblyField in
            self.byteCalc.assemblyField = assemblyField
        }
        
        
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        
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
    
    
    func newProjectBtnPressed() {
        switch projectModel.fsState {
        case .UnsavedNamed:
            // project was edited

            let alertController = UIAlertController(title: "Want to save?", message: "Would you like to save your changes to the current project?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                print("saving changes and creating a new project")
                projectModel.saveProject()
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
                projectModel.saveProject()
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
            projectModel.saveProject()

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
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailComposeViewController.addAttachmentData(projectModel.getData(ofType: ProjectContents.source), mimeType: "txt", fileName: projectModel.name.appending(".pep"))
            mailComposeViewController.addAttachmentData(projectModel.getData(ofType: ProjectContents.object), mimeType: "txt", fileName: projectModel.name.appending(".pepo"))
            mailComposeViewController.addAttachmentData(projectModel.getData(ofType: ProjectContents.listing), mimeType: "txt", fileName: projectModel.name.appending(".pepl"))
            self.present(mailComposeViewController, animated: true, completion: nil)
//            if let fileData = projectModel.sourceStr.data(using: .utf8) {
//                print("File data lauded.")
//                mailComposeViewController.addAttachmentData(fileData as Data, mimeType: "pep", fileName: projectModel.name)
//                self.present(mailComposeViewController, animated: true, completion: nil)
//            }
            
            // } ENDTODO
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    /// Try to load the given example.  Depending on `self.fsState`, this function may present the user with options (e.g. if the user has never saved the current project) before loading the given example.  If the user chooses to cancel this save operation, the function returns false.
    func attemptToLoadExample(text: String, ofType: PepFileType) -> Bool {
        var shouldLoad: Bool = true
        switch projectModel.fsState {
        case .UnsavedNamed:
            // project has not been saved recently
            // rather than present an alertController here, I say we just update the fs automatically
            projectModel.saveProject()
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
            exampleWasLoaded(ofType: ofType)
        }
        
        return shouldLoad
    }
    
    /// Switches the tabBar to the appropriate index.
    func exampleWasLoaded(ofType: PepFileType) {

        switch ofType {
        case .pep:
            // switch to SourceViewController
            tabBar.selectedIndex = 0
            
        case .pepo, .peph:
            // switch to ObjectViewController
            tabBar.selectedIndex = 1

        default:
            break
        }
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
    func assembleSource() -> Bool {
        
        // PLACEHOLDER
        return true

//        burnCount = 0
//        if assembler.assemble() {
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
//            objectVC.setObjectCode(assembler.getObjectCode())
//            listingVC.setListing(assembler.getListing())
//            traceVC.setListing(assembler.getListingForTrace())
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
    
    
    
    /// Called whenever the user taps the 'Load Object' button.  This function...
    
    /// * loads assembler.object into memory, if it exists
    /// * refreshes the memory dump
    
    func loadObject() -> Bool {
        // TODO
        return true
    }
    
    
    
    
    
    
    
    
    
}
