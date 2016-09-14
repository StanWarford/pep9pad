//
//  HelpMasterViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/8/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class HelpMasterViewController: UITableViewController {

    // MARK: - Internal Variables
    internal var helpDetail: HelpDetailViewController!
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController: UINavigationController = self.splitViewController?.viewControllers[1] as! UINavigationController
        helpDetail = navController.viewControllers[0] as! HelpDetailViewController
    }

    // MARK: - IBOutlets
    @IBAction func closeBtnPressed(_ sender: UIBarButtonItem) {
        helpDetail.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Overriding UITableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var v: UITableViewCell
        if let aPreexistingCell = tableView.dequeueReusableCell(withIdentifier: "helpID") {
            v = aPreexistingCell
        } else {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "helpID")
            v = tableView.dequeueReusableCell(withIdentifier: "helpID")!
        }
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            v.textLabel!.text = Array(Documentation.allValues.values)[(indexPath as NSIndexPath).row]
        case 1:
            v.textLabel!.text = Examples.allValues[(indexPath as NSIndexPath).row].rawValue
        case 2:
            v.textLabel!.text = Examples.allValues[(indexPath as NSIndexPath).row + 40].rawValue
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
            helpDetail.loadDocumentation(Array(Documentation.allValues.keys)[(indexPath as NSIndexPath).row])
        case 1:
            helpDetail.loadExample((tableView.cellForRow(at: indexPath)?.textLabel!.text)!)
        case 2:
            helpDetail.loadExample((tableView.cellForRow(at: indexPath)?.textLabel!.text)!)
        default:
            print("Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Documentation.allValues.count
        case 1:
            return Examples.allValues.count - 8
        case 2:
            return 8
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
        default:
            return ""
        }
    }
    
    
    
    
}
