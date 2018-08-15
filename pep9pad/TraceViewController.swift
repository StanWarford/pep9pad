//
//  SplitTraceViewController.swift
//  pep9pad
//
//  Created by James Maynard on 6/12/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class TraceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /// Updated in `self.update()`
    /// Set to `machine.isTrapped && machine.shouldTraceTraps`
    var traceOS: Bool = false
    /// Keeps track of the listing as represented in `assembler.listing`.
    var cachedListing: [String] = []
    
    var stackFrameFSM = StackFrameFSM()

    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.drawBottomOfStack(stackView.frame)
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //tableView.separatorStyle = .none
            tableView.addBorder()

        }
    }
    
    @IBOutlet weak var stackView: StackVC!
    
    /// Used to get a CGRect for the root of the stack.
    @IBOutlet var stackRootLabel: UILabel!
    
    /// Used to get a CGRect for the root of the globals.
    @IBOutlet var globalRootLabel: UILabel!
    
    /// Used to get a CGRect for the root of the heap.
    @IBOutlet var heapRootLabel: UILabel!
    

    /// The stack of cells.
    var stack: [StackCell] = []
    
    var globals: [StackCell] = []
    
    var heap: [StackCell] = []
    
    /// This is used to give us what we're pushing onto the stack before we get there
    var lookAheadSymbols: [String] = []
    
    
    /// This function should be called at the beginning of a debug session
    func loadGlobals() {
        // loop through the .BLOCK symbols
        for i in 0..<maps.blockSymbols.count {
            let blockSymbol = maps.blockSymbols[i]
            let multiplier = maps.symbolFormatMultiplier[blockSymbol]
            let address = maps.symbolTable[blockSymbol]
            
            // if it's a struct...
            if maps.globalStructSymbols.keys.contains(where: {$0 == blockSymbol}) {
        
                var offset = 0
                var bytesPerCell = 0
                var structField = ""
                
                // loop through the symbols
                for j in 0..<maps.globalStructSymbols[blockSymbol]!.count {
                    structField = maps.globalStructSymbols[blockSymbol]![j]
                    bytesPerCell = machine.cellSize(symbolFormat: maps.symbolFormat[structField]!)
                    addCell(to: .global, address: address!+offset, value: "0", name: "\(blockSymbol).\(structField)", fmt: maps.symbolFormat[structField]!)
                    offset += bytesPerCell
                }
            }
                
            // otherwise it's either a single global or a global array...
            else {
                if multiplier == 1 {
                    // a single global variable
                    addCell(to: .global, address: address!, value: 0.toHex4(), name: blockSymbol, fmt: maps.symbolFormat[blockSymbol]!)
                    
                } else {
                    // an array
                    var offset = 0
                    let bytesPerCell = machine.cellSize(symbolFormat: maps.symbolFormat[blockSymbol]!)
                    for j in 0..<multiplier! {
                        addCell(to: .global, address: address!+offset, value: 0.toHex4(), name: blockSymbol+"[\(j)]", fmt: maps.symbolFormat[blockSymbol]!)
                        offset += bytesPerCell
                    }
                    
                }
            
            }
       
        }
        // reset the stack frame
        stackFrameFSM.reset()
    }
    
    
    
    func updateHeap() {
        if machine.isTrapped {
            return
        }
        
        if maps.decodeMnemonic[machine.instructionSpecifier] == .CALL &&
            maps.symbolTable["malloc"] == machine.operandSpecifier {
            // heap allocation
            var numCellsToAdd = 0
            var offset = 0
            var multiplier = 0
            var heapSymbol = ""
            var heapPointer = 0
            
            if maps.symbolTable.contains(where: {$0.key == "hpPtr"}) {
                heapPointer = maps.symbolTable["hpPtr"]!
            } else {
                // ERROR, we have no idea where the heap pointer is.
                // TODO: put halt here
                assert(false)
            }
            
            var numBytes = 0
            // Check and make sure the accumulator matches the number of bytes we're mallocing:
            // We'll start by adding up the number of bytes...
            for i in 0..<lookAheadSymbols.count {
                heapSymbol = lookAheadSymbols[i]
                if maps.equateSymbols.contains(heapSymbol) ||
                    maps.blockSymbols.contains(heapSymbol) {
                    // numBytes += number of bytes for that tag * the multiplier (IE, 2d4a is a 4 cell array of 2 byte decimals, where 2 is the multiplier and 4 is the number of cells.
                    // Note: the multiplier should always be 1 for malloc'd cells, but that's checked below, where we'll give a more specific error.
                    numBytes += assembler.tagNumBytes(symbolFormat: maps.symbolFormat[heapSymbol]!) * maps.symbolFormatMultiplier[heapSymbol]!
                }
            }
            
            // verify that this is indeed the number in the accumulator...
            if numBytes != machine.accumulator {
                // TODO implement this error
                assert(false)
                //"Warning: The accumulator doesn't match the number of bytes in the trace tags"
                //return
            }
            
            for i in 0..<lookAheadSymbols.count {
                heapSymbol = lookAheadSymbols[i]
                if maps.equateSymbols.contains(heapSymbol) ||
                    maps.blockSymbols.contains(heapSymbol) {
                    multiplier = maps.symbolFormatMultiplier[heapSymbol]!
                }
                else {
                    assert(false)
                    //ui->warningLabel->setText("Warning: Symbol \"" + heapSymbol + "\" not found in .equates, unknown size.");
                    //return;
                }
                
                
                if multiplier == 1 {
                    // We can't support arrays on the stack with our current addressing modes.
                    // All our prereqs have been met to make an item
                    // make new cell and add it to the heap
                    addCell(to: .heap, address: machine.readWord(heapPointer)+offset, value: "0", name: heapSymbol, fmt: maps.symbolFormat[heapSymbol]!)
                    offset += machine.cellSize(symbolFormat: maps.symbolFormat[heapSymbol]!)
                    numCellsToAdd += 1
                }
            }
            
            if numCellsToAdd != 0 {
                addFrame(target: .heap, size: numCellsToAdd)
            }
        }
    }
    
    /// Moves the heap up by one cell.
    func moveUpOneCell(target: CellLocation) {
        if target == .heap {
            for i in 0..<heap.count {
                // change the center location
                heap[i].center.y -= CELL_HEIGHT
            }
            // if moving the heap, must move the heap frames too
            for i in 0..<heapFrames.count {
                heapFrames[i].center.y -= CELL_HEIGHT
            }
            
        } else if target == .global {
            for i in 0..<globals.count {
                globals[i].center.y -= CELL_HEIGHT
            }
            
        } else {
            // this is unsupported behavior
            print("Why are you moving the stack up one cell?")
            return
        }
    }
    
 //   var bytesWrittenLastStep: [Int] = []
 //   var delayLastStepClear: Bool = false
    
    func cacheChanges() {
        switch (maps.decodeMnemonic[machine.readByte(machine.programCounter)]) {
        case .ADDSP, .CALL, .RET, .SUBSP:
            if maps.symbolTraceList.keys.contains(where: {$0 == machine.programCounter}) {
                lookAheadSymbols = maps.symbolTraceList[machine.programCounter]!
            }
        default:
            break
        }
    }
    
    /// Remove n bytes from the stack.
    func popBytes(n: Int) {
        var numBytes = n
        
        var frameSizes: [Int] = []
        
        // figure out the frames
        for f in stackFrames {
            frameSizes.append(f.size)
        }
        
        while numBytes > 0 && stack.count > 0 {
            stack.last?.removeFromSuperview()
            numBytes -= machine.cellSize(symbolFormat: stack.last!.fmt)
            stack.removeLast()

            // sum is equivalent to array.reduce(0, +)
            if frameSizes.reduce(0, +) > stack.count {
                stackFrames.last?.removeFromSuperview()
                stackFrames.removeLast()
                frameSizes.removeLast()
            }
        }
    }
    
    
    func removeAllCells() {
        for i in stack {
            i.removeFromSuperview()
        }
        
        for i in globals {
            i.removeFromSuperview()
        }
        
        for i in heap {
            i.removeFromSuperview()
        }
        
        for i in heapFrames {
            i.removeFromSuperview()
        }
        
        for i in stackFrames {
            i.removeFromSuperview()
        }
        
        stack.removeAll()
        globals.removeAll()
        heap.removeAll()
        heapFrames.removeAll()
        stackFrames.removeAll()
    }
    
    
    
    var stackFrames: [FrameCell] = []
    var heapFrames: [FrameCell] = []
    
    
    /// Adds a `FrameCell` to `stackFrames` or `heapFrames`.
    func addFrame(target: CellLocation, size: Int) {
    
        var unitCell = CGRect(x: 0, y: 0, width: 47, height: 23)

        var cell: FrameCell?

        if target == .stack {
            let theFrame = unitCell.applying(CGAffineTransform(scaleX: 1.0, y: CGFloat(size)))
            print(theFrame)
            cell = FrameCell(frame: theFrame)
            cell!.size = size
            cell!.backgroundColor = .clear
            cell!.layer.borderColor = UIColor.black.cgColor
            cell!.layer.borderWidth = 3.0
            cell!.frame.origin = stack.last!.convert(stack.last!.valueLabel.frame.origin, to: stackView)
        } else {
           let theFrame = heap.last!.valueLabel.frame.applying(CGAffineTransform(scaleX: 1.0, y: CGFloat(size)))
            cell = FrameCell(frame: theFrame)
            cell!.size = size
            cell!.backgroundColor = .clear
            cell!.layer.borderColor = UIColor.black.cgColor
            cell!.layer.borderWidth = 3.0
            cell!.frame.origin = heap[size-1].convert(heap[size-1].valueLabel.frame.origin, to: stackView).applying(CGAffineTransform(translationX: 0, y: -CELL_HEIGHT))
        }
        
        // add it to the StackView
        stackView.addSubview(cell!)
        
        // and add it to the list of frames
        if (target == .stack) {
            stackFrames.append(cell!)
        } else {
            heapFrames.append(cell!)
        }
    }
    
    
    
    func updateStack() {
        if machine.isTrapped {
            return
        }
        
        var multiplier = 0
        var bytesPerCell = 0
        var offset = 0
        var numCellsToAdd = 0
        var frameSizeToAdd = 0
        var stackSymbol = ""
        var fmt: ESymbolFormat = .F_NONE
        
        switch (maps.decodeMnemonic[machine.instructionSpecifier]) {
        case .CALL:
            addCell(to: .stack, address: machine.stackPointer, value: "0",
                    name: "retAddr", fmt: .F_2H)
            frameSizeToAdd = stackFrameFSM.makeTransition(numCellsToAdd: 1)
        case .SUBSP:
            for i in 0..<lookAheadSymbols.count {
                stackSymbol = lookAheadSymbols[i]
                multiplier = maps.symbolFormatMultiplier[stackSymbol]!
                fmt = maps.symbolFormat[stackSymbol]!
                
                if multiplier == 1 { // single cell
                    offset += machine.cellSize(symbolFormat: fmt)
                    addCell(to: .stack, address: machine.stackPointer-offset+machine.operandSpecifier, value: "0",
                            name: stackSymbol, fmt: fmt)
                    stack.last?.updateValue()
                    numCellsToAdd += 1
                    
                } else { //array on the stack
                    bytesPerCell = machine.cellSize(symbolFormat: fmt)
                    var k = multiplier-1
                    for j in 0..<multiplier {
                        offset += bytesPerCell
                        addCell(to: .stack, address: machine.stackPointer-offset+machine.operandSpecifier, value: "0", name: stackSymbol+"[\(k)]", fmt: fmt)
                        stack.last?.updateValue()
                        numCellsToAdd += 1
                        k -= 1
                    }
                }
            }
            frameSizeToAdd = stackFrameFSM.makeTransition(numCellsToAdd: numCellsToAdd)
        case .RET:
            popBytes(n: 2)
            frameSizeToAdd = stackFrameFSM.makeTransition(numCellsToAdd: 0)
        case .ADDSP:
            popBytes(n: machine.operandSpecifier)
            frameSizeToAdd = stackFrameFSM.makeTransition(numCellsToAdd: 0)
        default:
            frameSizeToAdd = stackFrameFSM.makeTransition(numCellsToAdd: 0)
            break
        }
        

        if frameSizeToAdd != 0 && stack.count >= frameSizeToAdd {
            // need to add a stack frame
            print("adding stack frame of size \(frameSizeToAdd)")
            addFrame(target: .stack, size: frameSizeToAdd)
        }
    }
    
    
    
    /// Update the values of all cells.
    /// Cells will automatically change color if their value was changed.
    func updateCells() {
        for cell in stack {
            cell.updateValue()
        }
        
        for cell in globals {
            cell.updateValue()
        }
        
        for cell in heap {
            cell.updateValue()
        }
    }
    
    
    let CELL_HEIGHT: CGFloat = 23.0
    
    enum CellLocation {
        case global
        case heap
        case stack
    }
    
    /// Add a cell to one of the three locations.
    func addCell(to: CellLocation, address: Int,
                 value: String, name: String, fmt: ESymbolFormat) {
        
        let v: StackCell = (Bundle.main.loadNibNamed(
            "StackCell", owner: nil, options: nil)?.first as? UIView) as! StackCell
        
        
        v.addr = address
        v.addressLabel.text = address.toHex4()
        v.valueLabel.text = value
        v.nameLabel.text = name
        v.fmt = fmt
        
        switch (to) {
        case .stack:
            if stack.isEmpty {
                v.center = self.stackRootLabel.center.applying(
                    CGAffineTransform(translationX: -25, y: -25)
                )
            } else {
                v.center = stack.last!.center.applying(
                    CGAffineTransform(translationX: 0, y: -CELL_HEIGHT)
                )
            }
            stack.append(v)
            stackView.addSubview(stack.last! as UIView)
            
        case .heap:
            if heap.isEmpty {
                v.center = self.heapRootLabel.center.applying(
                    CGAffineTransform(translationX: 25, y: -25)
                )
            } else {
                moveUpOneCell(target: .heap)
                v.center = heap.last!.center.applying(
                    CGAffineTransform(translationX: 0, y: CELL_HEIGHT)
                )
            }
            heap.append(v)
            stackView.addSubview(heap.last! as UIView)
            
        case .global:
            if globals.isEmpty {
                v.center = self.globalRootLabel.center.applying(
                    CGAffineTransform(translationX: 25, y: -25)
                )
            } else {
                moveUpOneCell(target: .global)
                v.center = globals.last!.center.applying(
                    CGAffineTransform(translationX: 0, y: CELL_HEIGHT)
                )
            }
            globals.append(v)
            stackView.addSubview(globals.last! as UIView)
        }
    }
    

    
    
    func loadFromListing() {
        tableView.reloadData()
        cachedListing = assembler.listing
    }
    
    
    /// Checks to see if the listing is different, and updates if so.
    func reloadTableIfNeeded() {
        /// TODO: Compute hash of text rather than elementwise comparison?
        if traceOS {
            if assembler.osListing != cachedListing {
                cachedListing = assembler.osListing
                tableView.reloadData()
            }
        } else {
            if assembler.listing != cachedListing {
                cachedListing = assembler.listing
                tableView.reloadData()
            }
        }
    }
    
    func update() {
        //addCell()
        traceOS = machine.isTrapped && machine.shouldTraceTraps
        reloadTableIfNeeded()
        updateCells()
        
        // select a row corresponding to the current instruction
        if traceOS {
            // we are tracing the operating system...
            if let row = maps.memAddrssToAssemblerListingOS[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0),
                                    animated: true, scrollPosition: .middle)
            } else {
                print("error for \(machine.programCounter) in OS")
            }
        } else {
            // we are tracing a user program...
            // select a row corresponding to the current instruction
            if let row = maps.memAddrssToAssemblerListing[machine.programCounter] {
                tableView.selectRow(at: IndexPath(row: row, section: 0),
                                    animated: true, scrollPosition: .middle)
            } else {
                print("error for \(machine.programCounter) in prog")
                
            }
        }
        
        
        // now update the stack
        cacheChanges()
        updateStack()
        updateHeap()
        
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
                cell.textLabel?.font = UIFont(name: "Courier", size: 12.0)!
            }
        } else {
            // then fill it with the appropriate content
            if index < assembler.listing.count {
                //cell.textLabel?.text = assembler.listing[index]
                cell.textLabel?.attributedText = NSAttributedString(string: assembler.listing[indexPath.row])
                cell.textLabel?.font = UIFont(name: "Courier", size: 12.0)!
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

