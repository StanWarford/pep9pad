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
    
    internal var isCPU = false
    
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController: UINavigationController = self.splitViewController?.viewControllers[1] as! UINavigationController
        helpDetail = navController.viewControllers[0] as! HelpDetailController
        helpDetail.setup(master: self)
        // TODO: set selected index
        //let indexPath = IndexPath(row: 2, section: 0)
        //tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
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
        if !isCPU {
            self.asmMasterVC.loadExample(text, ofType: ofType, io: io, usesTerminal: usesTerminal)
            self.close()
        }else {
            self.cpuMasterVC.loadExample(text: text)
            self.close()
        }
    }
    
    
    
    

    // MARK: - IBOutlets
    @IBAction func closeBtnPressed(_ sender: UIBarButtonItem) {
        self.close()
    }
    
    func close() {
        helpDetail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Overriding UITableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: Set selection style for cells
        
        var v: UITableViewCell
        if let aPreexistingCell = tableView.dequeueReusableCell(withIdentifier: "helpID") {
            v = aPreexistingCell
        } else {
            v = UITableViewCell(style: .subtitle, reuseIdentifier: "helpID")
        }
        
        v.detailTextLabel?.lineBreakMode = .byWordWrapping
        v.detailTextLabel?.numberOfLines = 4
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            v.textLabel!.text = Array(Documentation.allValues.values)[(indexPath as NSIndexPath).row]
            v.detailTextLabel!.text = ""
        case 1:
            v.textLabel!.text = Figures.allValues[indexPath.row].rawValue
            v.detailTextLabel!.text = FigureDescriptions.allValues[indexPath.row].rawValue
        case 2:
            v.textLabel!.text = Problems.allValues[indexPath.row].rawValue
            v.detailTextLabel!.text = ProblemDescriptions.allValues[indexPath.row].rawValue
        case 3:
            v.textLabel!.text = "Pep/9 Operating System"
            v.detailTextLabel!.text = ""
        default:
            v.textLabel?.text = "Error"
        }
        
        v.selectionStyle = .blue
        
        return v
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            helpDetail.loadDocumentation(Array(Documentation.allValues.keys)[(indexPath as NSIndexPath).row])
        case 1:
            helpDetail.loadExample(Figures.allValues[indexPath.row].rawValue)
        case 2:
            helpDetail.loadExample(Problems.allValues[indexPath.row].rawValue)
        case 3:
            helpDetail.loadExample("Pep/9 Operating System")
        default:
            print("Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Documentation.allValues.count
        case 1:
            return Figures.allValues.count
        case 2:
            return Problems.allValues.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Documentation"
        case 1:
            return "Figures"
        case 2:
            return "Problems & Examples"
        case 3:
            return "Operating System"
        default:
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    
}
