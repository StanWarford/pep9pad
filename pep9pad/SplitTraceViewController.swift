//
//  SplitTraceViewController.swift
//  pep9pad
//
//  Created by James Maynard on 6/12/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class SplitTraceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var traceOS: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackView: UIView!
    
    func makeDivider() {
        //Called in Update, TODO: Make only Bottom Boarder on TableView
    tableView!.layer.borderWidth = 1
    tableView!.layer.borderColor = UIColor.black.cgColor
        // TODO: Why Broken?
//    stackView!.layer.borderWidth = 1
//    stackView!.layer.borderColor = UIColor.black.cgColor
    }

    
    func loadFromListing() {
        tableView.reloadData()
    }
    
    
    func update() {
        makeDivider()
        // depends on whether we are in the OS or a program
        if machine.isTrapped && machine.shouldTraceTraps { // we are in the OS
            if !traceOS {
                // this is the first we are hearing about the trapped state
                traceOS = true
            }
            tableView.reloadData()
            // select a row corresponding to the current instruction
            if let row = maps.memAddrssToAssemblerListingOS[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0),
                                    animated: true, scrollPosition: .middle)
                //tableView.reloadData()
            } else {
                print("error for \(machine.programCounter) in OS")
            }
        } else { // we are in a user program
            if traceOS {
                // this is the first we are hearing about the untrapped state
                traceOS = false
                //tableView.reloadData()
            }
            tableView.reloadData()
            // select a row corresponding to the current instruction
            if let row = maps.memAddrssToAssemblerListing[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0),
                                    animated: true, scrollPosition: .middle)
                //tableView.reloadData()
            } else {
                print("error for \(machine.programCounter) in prog")
            }
            // TODO: prog?
        }
        
        
    }
    
    
    
    // Conformance to UITableViewDataSource (subclass of UITableViewController)
    
    
    let idForCell = "traceTableCellID"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                cell.textLabel?.font = UIFont(name: "Courier", size: 15.0)!
            }
        } else {
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
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = blueColor
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return traceOS ? assembler.osListing.count : assembler.listing.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }


}
