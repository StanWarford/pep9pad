//
//  MemoryController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class MemoryController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var table: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var textField: UIBarButtonItem!
    @IBOutlet var spBtn: UIBarButtonItem!
    @IBOutlet var pcBtn: UIBarButtonItem!
    
    @IBAction func spBtnPressed(_ sender: UIBarButtonItem) {
        // TODO: Scroll `table` to sp
    }
    
    
    @IBAction func pcBtnPressed(_ sender: UIBarButtonItem) {
        // TODO: Scroll `table` to pc
    }
    
    
    
}
