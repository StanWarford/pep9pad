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
    
    func makeAlert(barButton: UIBarButtonItem) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let controller = UIViewController()
        var tableView = UITableView()
        let rect = CGRect(x: 0, y: 0, width: 272, height: 130) // adjust only `height` argument, don't mess with the others
        tableView = UITableView(frame: rect)
        controller.preferredContentSize = rect.size
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // tableView.separatorEffect    <- what is this?
        tableView.separatorColor = .clear
        tableView.tag = 1002
        
        tableView.register(UINib(nibName: "FontMenuColorCell", bundle: nil), forCellReuseIdentifier: "colorScheme")
        tableView.register(UINib(nibName: "FontMenuSizeCell", bundle: nil), forCellReuseIdentifier: "fontSize")

        
        controller.view.addSubview(tableView)
        controller.view.bringSubview(toFront: tableView)
        controller.view.isUserInteractionEnabled = true
        
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.clear
        
        alertController.setValue(controller, forKey: "contentViewController")
        
        alertController.popoverPresentationController?.barButtonItem = barButton
        
        return alertController

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 87
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "colorScheme") {
                cell.backgroundColor = UIColor.clear
                
                // set cell's textLabel.text property
                // set cell's detailTextLabel.text property
                return cell
            } else {
                return UITableViewCell()
            }

        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fontSize") {
                cell.backgroundColor = UIColor.clear
                
                // set cell's textLabel.text property
                // set cell's detailTextLabel.text property
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()

        }
    }

}
