//
//  TraceTableController.swift
//  pep9pad
//
//  Created by Josh Haug on 12/22/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit



class TraceTableController: UITableViewController {
    
    
    var traceOS: Bool = false
    
    
    var shouldUpdate: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func loadFromListing() {
        tableView.reloadData()
    }
    
    
    func update() {
        
        /* THIS BLOCK SHOULD BE SIMPLIFIED */
        // depends on whether we are in the OS or a program
        if machine.isTrapped && machine.shouldTraceTraps { // we are in the OS

            // select a row corresponding to the current instruction
            if let row = maps.memAddrssToAssemblerListingOS[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0),
                                    animated: true, scrollPosition: .middle)
            } else {
                print("error for \(machine.programCounter) in OS")
            }
        } else { // we are in a user program
            if traceOS {
                // this is the first we are hearing about the untrapped state
                traceOS = false
            }
            
            // reloadData is called _before_ selectRow
            if shouldUpdate {
                tableView.reloadData()
            }
            
            // select a row corresponding to the current instruction
            if let row = maps.memAddrssToAssemblerListing[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0),
                                    animated: true, scrollPosition: .middle)
            } else {
                print("error for \(machine.programCounter) in prog")
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
        
        if traceOS {
            if index < assembler.osListing.count {
                cell.textLabel?.attributedText = NSAttributedString(string: assembler.osListing[indexPath.row])
                cell.textLabel?.font = UIFont(name: "Courier", size: 10.0)!
            }
        } else {
            // then fill it with the appropriate content
            if index < assembler.listing.count {
                //cell.textLabel?.text = assembler.listing[index]
                cell.textLabel?.attributedText = NSAttributedString(string: assembler.listing[indexPath.row])
                cell.textLabel?.font = UIFont(name: "Courier", size: 10.0)!
            } else {
                // out of bounds!
                // probably was not updated recently, so do that now
                self.update()
            }
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = lighterBlueColor
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return traceOS ? assembler.osListing.count : assembler.listing.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
