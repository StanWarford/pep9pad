//
//  HelpMasterController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class HelpMasterController: UITableViewController {

    // MARK: - Internal Variables
    internal var helpDetail: HelpDetailController!
    internal var asmMasterVC: Pep9MasterController!
    internal var cpuMasterVC: CPUViewController!
    
    var codeSide : HelpDelegate! /// needs a different name
    
    internal var isCPU = false
    
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController: UINavigationController = self.splitViewController?.viewControllers[1] as! UINavigationController
        helpDetail = navController.viewControllers[0] as! HelpDetailController
        
        // TODO: set selected index
        //let indexPath = IndexPath(row: 2, section: 0)
        //tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    func setup(master: HelpDelegate, tableDelegate : UITableViewDelegate, dataSource : UITableViewDataSource){
        self.codeSide = master
        self.tableView.delegate = tableDelegate
        self.tableView.dataSource = dataSource
        
        codeSide.helpDetail = helpDetail
        helpDetail.setup(master: self)
    }
    
    func setup(mvc: Pep9MasterController) {
        self.asmMasterVC = mvc
        isCPU = false
    }
    
    func setup(cpu : CPUViewController){
        self.cpuMasterVC = cpu
        isCPU = true
    }
    
    
    
    
    func loadExample(_ text: String, ofType: PepFileType, io: String!, usesTerminal: Bool) {
        self.codeSide.loadExampleToProj(text, ofType: ofType, io: io, usesTerminal: usesTerminal)
        self.close()
    }
    
    
    
    

    // MARK: - IBOutlets
    @IBAction func closeBtnPressed(_ sender: UIBarButtonItem) {
        self.close()
    }
    
    func close() {
        helpDetail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    
}
