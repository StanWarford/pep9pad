//
//  TraceTableController.swift
//  pep9pad
//
//  Created by Josh Haug on 12/22/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit



class TraceTableController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Conformance to UITableViewDataSource (subclass of UITableViewController)
    
    
    let idForCell = "traceTableCellID"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let index = indexPath.row
        
        // create or dequeue a cell
        if let temp = tableView.dequeueReusableCell(withIdentifier: idForCell) {
            cell = temp
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: idForCell)
        }
        
        // then fill it with the appropriate content
        if index < assembler.listing.count {
            //cell.textLabel?.text = assembler.listing[index]
            cell.textLabel?.attributedText = NSAttributedString(string: assembler.listing[indexPath.row])
            cell.textLabel?.font = UIFont(name: "Courier", size: 15.0)!

        } else {
            cell.textLabel?.text = "ERROR: Index \(index) out of bounds."
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return assembler.listing.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
