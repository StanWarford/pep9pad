//
//  FSMasterController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class FSMasterController: UITableViewController {
    // MARK: - Internal Variables
    internal var detail: FSDetailController!
    internal var asmDetail: Pep9DetailController!
    internal var names: [String] = []
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController: UINavigationController = self.splitViewController?.viewControllers[1] as! UINavigationController
        detail = navController.viewControllers[0] as! FSDetailController
        names = p9FileSystem.loadProjectNames()
    }
    
    func setup(asmDetailVC: Pep9DetailController) {
        asmDetail = asmDetailVC
    }
    
    // MARK: - IBOutlets
    @IBAction func closeBtnPressed(_ sender: UIBarButtonItem) {
        detail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Overriding UITableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var v: UITableViewCell
        if let aPreexistingCell = tableView.dequeueReusableCell(withIdentifier: "fsID") {
            v = aPreexistingCell
        } else {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "fsID")
            v = tableView.dequeueReusableCell(withIdentifier: "fsID")!
        }
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            v.textLabel!.text = names[indexPath.row]
        default:
            v.textLabel?.text = "Error"
        }
        
        v.selectionStyle = .blue
        
        return v
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            detail.loadFile(names[indexPath.row])
        default:
            print("Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return names.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Your Projects"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Allow swipe-to-delete functionality
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // Desired behavior shows a red Delete button after swipe
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if p9FileSystem.removeProject(named: names[indexPath.row]) {
                // deletion was successful
                // now we must reload `names` array
                names = p9FileSystem.loadProjectNames()
                // after reloading the array, we update the table
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                detail.clear()
            }
        }
    }

    
    
}
