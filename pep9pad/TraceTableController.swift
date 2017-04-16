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
    
    
    func loadFromListing() {
        tableView.reloadData()
    }
    
    
    func update() {
        // depends on whether we are in the OS or a program
        if machine.isTrapped { // we are in the OS
            // populate table with listing for os
        } else { // we are in a user program
            // populate table ith litign for program
            
            // TODO: prog?
            if let row = maps.memAddrssToAssemblerListing[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0)
, animated: true, scrollPosition: .top)
            }
        }
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
            // out of bounds!
            // probably was not updated recently, so do that now
            self.update()
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = blueColor
        cell.selectedBackgroundView = backgroundView
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
