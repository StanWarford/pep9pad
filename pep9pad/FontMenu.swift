//
//  FontMenu.swift
//  pep9pad
//
//  Created by Josh Haug on 2/22/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
class FontMenu: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    override init() {
        //prepare
    }
    
    func makeAlert() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let controller = UIViewController()
        var tableView = UITableView()
        let rect = CGRect(x: 0, y: 0, width: 272, height: 200) // adjust last arg to make bigger/smaller
        tableView = UITableView(frame: rect)
        controller.preferredContentSize = rect.size
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // tableView.separatorEffect    <- what is this?
        tableView.tag = 1002
        controller.view.addSubview(tableView)
        controller.view.bringSubview(toFront: tableView)
        controller.view.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clear
        
        alertController.setValue(controller, forKey: "contentViewController")
        
        let somethingAction = UIAlertAction(title: "act 1", style: .default, handler: {(alert: UIAlertAction!) in print("something")})
        let otherAction = UIAlertAction(title: "act 2", style: .default, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(otherAction)
        alertController.addAction(somethingAction)
        
        return alertController

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        
        // set cell's textLabel.text property
        // set cell's detailTextLabel.text property
        return cell
    }

}
