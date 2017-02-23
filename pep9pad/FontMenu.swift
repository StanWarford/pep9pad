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
        
        tableView.register(UINib(nibName: "FontMenuColorCell", bundle: nil), forCellReuseIdentifier: "colorScheme")
        
        controller.view.addSubview(tableView)
        controller.view.bringSubview(toFront: tableView)
        controller.view.isUserInteractionEnabled = true
        
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.clear
        
        alertController.setValue(controller, forKey: "contentViewController")
        
//        let somethingAction = UIAlertAction(title: "act 1", style: .default, handler: {(alert: UIAlertAction!) in print("something")})
//        let otherAction = UIAlertAction(title: "act 2", style: .default, handler: {(alert: UIAlertAction!) in print("cancel")})
//        
//        alertController.addAction(otherAction)
//        alertController.addAction(somethingAction)
        
        return alertController

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 69
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "colorScheme") {
            cell.backgroundColor = UIColor.clear
            
            // set cell's textLabel.text property
            // set cell's detailTextLabel.text property
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
