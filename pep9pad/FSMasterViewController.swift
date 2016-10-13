//
//  FSMasterViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/6/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class FSMasterViewController: UITableViewController {
    // MARK: - Internal Variables
    internal var detail: FSDetailViewController!
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController: UINavigationController = self.splitViewController?.viewControllers[1] as! UINavigationController
        detail = navController.viewControllers[0] as! FSDetailViewController
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
            v.textLabel!.text = "Example \(indexPath.row)"
        default:
            v.textLabel?.text = "Error"
        }
        
        v.selectionStyle = .blue
        
        return v
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            print("To be implemented.")
            //detail.loadFile((tableView.cellForRow(at: indexPath)?.textLabel!.text)!)
        default:
            print("Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 10
            //return number of files
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
}
