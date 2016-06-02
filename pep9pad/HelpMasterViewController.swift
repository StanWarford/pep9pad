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
    @IBAction func closeBtnPressed(sender: UIBarButtonItem) {
        helpDetail.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Overriding UITableViewController
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var v: UITableViewCell
        if let aPreexistingCell = tableView.dequeueReusableCellWithIdentifier("helpID") {
            v = aPreexistingCell
        } else {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "helpID")
            v = tableView.dequeueReusableCellWithIdentifier("helpID")!
        }
        
        switch indexPath.section {
        case 0:
            v.textLabel!.text = Array(Documentation.allValues.values)[indexPath.row]
        case 1:
            v.textLabel!.text = Examples.allValues[indexPath.row].rawValue
        case 2:
            v.textLabel!.text = Examples.allValues[indexPath.row + 40].rawValue
        default:
            v.textLabel?.text = "Error"
        }
        
        v.selectionStyle = .Blue
        
        return v
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            helpDetail.loadDocumentation(Array(Documentation.allValues.keys)[indexPath.row])
        case 1:
            helpDetail.loadExample((tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text)!)
        case 2:
            helpDetail.loadExample((tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text)!)
        default:
            print("Error")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
