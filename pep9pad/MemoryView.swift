//
//  MemoryView.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class MemoryView: UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
   
    
    
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
        // let viewName = NSStringFromClass(self.classForCoder)
        
        let view: UIView = Bundle.main.loadNibNamed("Memory", owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        refreshAll()
    }



    // MARK: - Methods

    var memoryDump: [String] = [String](repeating: "", count: 8192)
    
    
    /// Refreshes the whole memory pane.
    func refreshAll() {
        memoryDump.removeAll(keepingCapacity: true)
        var line: String = ""
        var ch: String
        
        for byte in stride(from: 0, to: 65536, by: 8){
            line = ""
            // address column
            line.append("\(byte.toHex4()) | ")
            // hex column
            for bit in 0..<8 {
                line.append("\(machine.mem[byte+bit].toHex2()) ")
            }
            line.append("| ")
            // ascii column
            for bit in 0..<8 {
                let val = machine.mem[byte+bit]
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
                line.append("\(machine.mem[byteNum+j].toHex2()) ")
            }
            
            line.append("| ")
            
            for j in 0..<8 {
                let val = machine.mem[byteNum+j]
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


    func scrollToByte(_ byte: Int) {
        let row: Int
        if byte % 8 == 0 {
            row = byte / 8
        } else {
            row = max(Int(byte/8), 1)
        }
        table.scrollToRow(at: IndexPath(row: row, section: 0), at: .none, animated: true)
        
    }
    
    
    

    // MARK: - IBOutlets and Actions 
    
    
    @IBOutlet var table: UITableView! {
        didSet {
            self.table.dataSource = self
            self.table.delegate = self
        }
    }
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var searchField: UITextField! {
        didSet {
            self.searchField.delegate = self
        }
    }
    @IBOutlet var spBtn: UIBarButtonItem!
    @IBOutlet var pcBtn: UIBarButtonItem!
    
    @IBAction func spBtnPressed(_ sender: UIBarButtonItem) {
        scrollToByte(machine.stackPointer)
    }
    
    
    @IBAction func pcBtnPressed(_ sender: UIBarButtonItem) {
        scrollToByte(machine.programCounter)
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
        
        cell?.textLabel?.attributedText = NSAttributedString(string: memoryDump[indexPath.row])
        cell?.textLabel?.font = UIFont(name: "Courier", size: 11.0)!
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8192//section == 1 ? 8192 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15
    }
    
    
    
    
    
    // MARK: - Conformance to UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as String
        
        if let intVal = Int(newText, radix: 16) {
            if intVal > 65536 {
                scrollToByte(65535)
            } else if intVal < 0 {
                scrollToByte(0)
            } else {
                scrollToByte(intVal)
            }
        }

        return true
    }
    
    
    
    
}
