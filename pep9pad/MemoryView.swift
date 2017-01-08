//
//  MemoryView.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class MemoryView: UIView { // , UITableViewDataSource {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        // below doesn't work as returned class name is normally in project module scope
        /*let viewName = NSStringFromClass(self.classForCoder)*/
        let view: UIView = Bundle.main.loadNibNamed("Memory", owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }

    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var textField: UIBarButtonItem!
    @IBOutlet var spBtn: UIBarButtonItem!
    @IBOutlet var pcBtn: UIBarButtonItem!
    
    @IBAction func spBtnPressed(_ sender: UIBarButtonItem) {
        print("SP button pressed")
        // TODO: Scroll `table` to sp
    }
    
    
    @IBAction func pcBtnPressed(_ sender: UIBarButtonItem) {
        print("PC button pressed")
        // TODO: Scroll `table` to pc
    }
    
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //0090 | 00 00 00 00 00 00 00 00 |........
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 1 ?
//    }
    
    
    
}
