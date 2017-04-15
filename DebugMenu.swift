//
//  DebugMenu.swift
//  pep9pad
//
//  Created by Josh Haug on 4/12/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit
class DebugMenu: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    override init() {
    }
    
    func makeAlert(barButton: UIBarButtonItem, detail: Pep9DetailController) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let controller = UIViewController()
        var tableView = UITableView()
        let rect = CGRect(x: 0, y: 0, width: 272, height: 55) // adjust only `height` argument, don't mess with the others
        tableView = UITableView(frame: rect)
        controller.preferredContentSize = rect.size
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // tableView.separatorEffect    <- what is this?
        tableView.separatorColor = .clear
        tableView.tag = 1003
        
        tableView.register(UINib(nibName: "DebugMenuTraceTrapsCell", bundle: nil), forCellReuseIdentifier: "traceTraps")
        
        
        controller.view.addSubview(tableView)
        controller.view.bringSubview(toFront: tableView)
        controller.view.isUserInteractionEnabled = true
        
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.clear
        
        alertController.setValue(controller, forKey: "contentViewController")
        
        alertController.popoverPresentationController?.barButtonItem = barButton
        
        let debugSourceAction = UIAlertAction(title: "Start Debugging Source", style: .default) { (action) in
            detail.startDebuggingSource()
        }
        alertController.addAction(debugSourceAction)
        let debugObjectAction = UIAlertAction(title: "Start Debugging Object", style: .default) { (action) in
            //TODO: Implement debugObjectAction
        }
        alertController.addAction(debugObjectAction)
        let debugLoaderAction = UIAlertAction(title: "Start Debugging Loader", style: .default) { (action) in
            //TODO: Implement debugLoaderAction
        }
        alertController.addAction(debugLoaderAction)
        
        return alertController
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "traceTraps") {
            cell.backgroundColor = UIColor.clear
            
            // set cell's textLabel.text property
            // set cell's detailTextLabel.text property
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
