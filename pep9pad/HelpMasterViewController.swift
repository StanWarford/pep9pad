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
        if indexPath.section == 0 {
            v.textLabel!.text = Examples.allValues[indexPath.row].rawValue
        }
        return v
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Implement
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Examples.allValues.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Examples"
        }
        return ""
    }
    
    
    
    
}
