//
//  MemoryView.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class MemoryView: UIView, UITableViewDataSource, UITableViewDelegate {
   
    
    
    // MARK: - Initializers
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
        refresh()
        for i in 0..<100 {
            machine.Mem[i]=i
        }
        refresh(fromByte: 0, toByte: 100)
    }



    // MARK: - Methods

    var memoryDump: [String] = [String](repeating: "", count: 8192)
    
    
    /// Refreshes the whole memory pane.
    func refresh() {
        memoryDump.removeAll(keepingCapacity: true)
        var line: String = ""
        var ch: String
        
        for byte in stride(from: 0, to: 65536, by: 8){
            line = ""
            line.append("\(byte.toHex4()) | ")
            
            for bit in 0..<8 {
                line.append("\(machine.Mem[byte+bit].toHex2()) ")
            }
            
            line.append("| ")
            
            for bit in 0..<8 {
                let val = machine.Mem[byte+bit]
                ch = val < 33 ? "." : val.toASCII()
                line.append(ch)
            }
            
            memoryDump.append(line)
            
        }
        
        
    }


    
    /// Refreshes the memory in a given range.  
    func refresh(fromByte: Int, toByte: Int) {
        let fromLine = fromByte / 8
        let toLine = toByte / 8
        
        var line: String
        var ch: String
        var byteNum: Int
        
        for lineNum in fromLine...toLine {
            line = ""
            byteNum = lineNum * 8
            line.append("\(byteNum.toHex4()) | ")
            
            for j in 0..<8 {
                line.append("\(machine.Mem[byteNum+j].toHex2()) ")
            }
            
            line.append("| ")
            
            for j in 0..<8 {
                let val = machine.Mem[byteNum+j]
                ch = val < 33 ? "." : val.toASCII()
                line.append(ch)
            }

        memoryDump[lineNum] = line
            
        }

    }

    func cacheModifiedBytes() {
    
    }
    /// If not b, whole table is unhighlighted. If b, current program counter is highlighted.
    func shouldHighlight(_ b: Bool) {
    
    }

    /// Highlights individual bytes.
    func hightlightByte(atAddr: Int, foreground: UIColor, background: UIColor) {
        
    }




    // MARK: - IBOutlets and Actions 
    
    @IBOutlet var table: UITableView! {
        didSet {
            self.table.dataSource = self
            self.table.delegate = self
        }
    }
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
    
    
    

    // MARK: - Conformance to UITableViewDataSource
    
    let cellID = "MemDumpCellID"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        cell?.textLabel?.text = memoryDump[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "Courier", size: 11.0)!
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8192//section == 1 ? 8192 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    
    
}
