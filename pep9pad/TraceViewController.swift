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
    /// When this changes,
    var cachedListing: [String] = []
    
    var stackFrameFSM = StackFrameFSM()

    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.drawBottomOfStack(stackView.frame)
        stackView.layer.borderColor = UIColor.orange.cgColor
        stackView.layer.borderWidth = 3.0
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackView: StackVC!
    
    // Used to get a CGRect for the root of the stack.
    @IBOutlet var stackRootLabel: UILabel!
    
    @IBOutlet var globalRootLabel: UILabel!
    
    @IBOutlet var heapRootLabel: UILabel!
    
    let screenHeight = UIScreen.main.bounds.height
    

    
    /// The stack of cells.
    var stack: [StackCell] = []
    
    var globals: [StackCell] = []
    
    var heap: [StackCell] = []
    
    /// This is used to give us what we're pushing onto the stack before we get there
    var lookAheadSymbols: [String] = []
    
    var modifiedBytes: Set<Int> = Set()
    
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
                
            // otherwise it's either a single global or a global array
            else {
                if multiplier == 1 {
                    // a single global variable
                    addCell(to: .global, address: address!, value: 0.toHex4(), name: blockSymbol, fmt: maps.symbolFormat[blockSymbol]!)
                    
                } else {
                    // an array
                    var offset = 0
                    var bytesPerCell = machine.cellSize(symbolFormat: maps.symbolFormat[blockSymbol]!)
                    for j in 0..<multiplier! {
                        addCell(to: .global, address: address!+offset, value: 0.toHex4(), name: blockSymbol+"[\(j)]", fmt: maps.symbolFormat[blockSymbol]!)
                        offset += bytesPerCell
                    }
                    
                }
            
            }
       
        }
        stackFrameFSM.reset()
    }
    
    
    
 //   var bytesWrittenLastStep: [Int] = []
 //   var delayLastStepClear: Bool = false
    
    func cacheChanges() {
//        modifiedBytes = modifiedBytes.union(machine.modifiedBytes)
//        if machine.shouldTraceTraps {
//            bytesWrittenLastStep.removeAll()
//            bytesWrittenLastStep = Array(machine.modifiedBytes)
//        } else if machine.isTrapped {
//            // We delay for a single vonNeumann step so that we preserve the
        //modified bytes until we leave the trap - this allows for
//            // recoloring of cells modified by a trap instruction.
//            delayLastStepClear = true
//            bytesWrittenLastStep.append(contentsOf: Array(machine.modifiedBytes))
//        } else if delayLastStepClear {
//            // Phew! We can now update (in updateMemoryTrace). If we don't, no harm done - they didn't want to see what happened in the trap
//            delayLastStepClear = false
//        } else {
//
//        }
        
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
        while numBytes > 0 && stack.count > 0 {
            stack.last?.removeFromSuperview()
            numBytes -= machine.cellSize(symbolFormat: stack.last!.fmt)
            stack.removeLast()
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
        
        stack.removeAll()
        globals.removeAll()
        heap.removeAll()
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
                    for j in multiplier-1...0 {
                        offset += bytesPerCell
                        addCell(to: .stack, address: machine.stackPointer-offset+machine.operandSpecifier, value: "0", name: stackSymbol+"[\(j)]", fmt: fmt)
                        stack.last?.updateValue()
                        numCellsToAdd += 1
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
        
        if frameSizeToAdd != 0 {
            // need to add a stack frame
            print("adding stack frame of size \(frameSizeToAdd)")
//            for i in 0..<frameSizeToAdd {
//                stack[i]
//            }
        }
    }
    
    
    
    /// Update the values of all cells
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
    
    enum CellLocation {
        case global
        case heap
        case stack
    }
    
    func addCell(to: CellLocation, address: Int,
                 value: String, name: String, fmt: ESymbolFormat) {
        
        let v: StackCell = (Bundle.main.loadNibNamed(
            "StackCell", owner: nil, options: nil)?.first as? UIView) as! StackCell
        
        // store the
        v.addr = address
        v.address.text = address.toHex4()
        v.value.text = value
        v.name.text = name
        v.fmt = fmt
        
        switch (to) {
        case .stack:
            v.center = (stack.isEmpty ? self.stackRootLabel.center.applying(CGAffineTransform(translationX: 0, y: -45)) : stack.last!.center.applying(CGAffineTransform(translationX: 0, y: -23)))
            stack.append(v)
            stackView.addSubview(stack.last! as UIView)
            
        case .heap:
            v.center = (heap.isEmpty ? self.heapRootLabel.center.applying(CGAffineTransform(translationX: 0, y: -45)) : heap.last!.center.applying(CGAffineTransform(translationX: 0, y: -23)))
            heap.append(v)
            stackView.addSubview(heap.last! as UIView)
            
        case .global:
            v.center = (globals.isEmpty ? self.globalRootLabel.center.applying(CGAffineTransform(translationX: 0, y: -45)) : globals.last!.center.applying(CGAffineTransform(translationX: 0, y: -23)))
            globals.append(v)
            stackView.addSubview(globals.last! as UIView)
        }
    }
    

    
    
    func loadFromListing() {
        tableView.reloadData()
    }
    
    
    
    func reloadTableIfNeeded() {
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



/*
 
 
 memoryTracePane->cacheChanges();
 memoryTracePane->cacheStackChanges();
 memoryTracePane->cacheHeapChanges();
 
 
void MemoryTracePane::setMemoryTrace()
{
    globalVars.clear();
    runtimeStack.clear();
    heap.clear();
    isRuntimeStackItemAddedStack.clear();
    isHeapItemAddedStack.clear();
    isStackFrameAddedStack.clear();
    isHeapFrameAddedStack.clear();
    stackHeightToStackFrameMap.clear();
    modifiedBytes.clear();
    bytesWrittenLastStep.clear();
    addressToGlobalItemMap.clear();
    addressToStackItemMap.clear();
    addressToHeapItemMap.clear();
    numCellsInStackFrame.clear();
    graphicItemsInStackFrame.clear();
    heapFrameItemStack.clear();
    newestHeapItemsList.clear();
    scene->clear();
    
    if (Pep::traceTagWarning) {
        hide();
        return;
    }
    
    stackLocation = QPointF(200, 0);
    globalLocation = QPointF(0, 0);
    heapLocation = QPointF(400, 0 - MemoryCellGraphicsItem::boxHeight);
    QString blockSymbol;
    int multiplier;
    
    // Globals:
    for (int i = 0; i < Pep::blockSymbols.size(); i++) {
        blockSymbol = Pep::blockSymbols.at(i);
        multiplier = Pep::symbolFormatMultiplier.value(blockSymbol);
        int address = Pep::symbolTable.value(blockSymbol);
        if (Pep::globalStructSymbols.contains(blockSymbol)) {
            int offset = 0;
            int bytesPerCell;
            QString structField = "";
            for (int j = 0; j < Pep::globalStructSymbols.value(blockSymbol).size(); j++) {
                structField = Pep::globalStructSymbols.value(blockSymbol).at(j);
                bytesPerCell = Sim::cellSize(Pep::symbolFormat.value(structField));
                MemoryCellGraphicsItem *item = new MemoryCellGraphicsItem(address + offset,
                QString("%1.%2").arg(blockSymbol).arg(structField),
                Pep::symbolFormat.value(structField),
                static_cast<int>(globalLocation.x()),
                static_cast<int>(globalLocation.y()));
                item->updateValue();
                globalLocation = QPointF(globalLocation.x(), globalLocation.y() + MemoryCellGraphicsItem::boxHeight);
                globalVars.push(item);
                addressToGlobalItemMap.insert(address + offset, item);
                scene->addItem(item);
                offset += bytesPerCell;
            }
        }
        else {
            if (multiplier == 1) {
                MemoryCellGraphicsItem *item = new MemoryCellGraphicsItem(address,
                                                                          blockSymbol,
                                                                          Pep::symbolFormat.value(blockSymbol),
                    static_cast<int>(globalLocation.x()),
                    static_cast<int>(globalLocation.y()));
                item->updateValue();
                globalLocation = QPointF(globalLocation.x(), globalLocation.y() + MemoryCellGraphicsItem::boxHeight);
                globalVars.push(item);
                addressToGlobalItemMap.insert(address, item);
                scene->addItem(item);
            }
 
            }
        }
    }
    
    //draw stack frame
    
    stackFrameFSM.reset();
}

 
 
 
 
 
void MemoryTracePane::updateMemoryTrace()
{
    // Color all of the cells normally (globals)
    for (int i = 0; i < globalVars.size(); i++) {
        globalVars.at(i)->boxBgColor = Qt::white;
        globalVars.at(i)->boxTextColor = Qt::black;
    }
    // Color all of the cells normally (stack)
    for (int i = 0; i < runtimeStack.size(); i++) {
        runtimeStack.at(i)->boxBgColor = Qt::white;
        runtimeStack.at(i)->boxTextColor = Qt::black;
    }
    // Color all of the cells normally (heap)
    for (int i = 0; i < heap.size(); i++) {
        heap.at(i)->boxBgColor = Qt::white;
        heap.at(i)->boxTextColor = Qt::black;
    }
    // Color the newest 'malloc' items on the heap light green
    for (int i = 0; i < newestHeapItemsList.size(); i++) {
        newestHeapItemsList.at(i)->boxBgColor = QColor(72, 255, 72, 192);
    }
    newestHeapItemsList.clear();
    
    // Add cached stack items to the scene
    for (int i = 0; i < runtimeStack.size(); i++) {
        if (!isRuntimeStackItemAddedStack.at(i)) {
            scene->addItem(runtimeStack.at(i));
            isRuntimeStackItemAddedStack[i] = true;
        }
    }
    // Add cached stack FRAME items to the scene
    for (int i = 0; i < isStackFrameAddedStack.size(); i++) {
        if (!isStackFrameAddedStack.at(i)) {
            scene->addItem(graphicItemsInStackFrame.at(i));
            isStackFrameAddedStack[i] = true;
        }
    }
    
    // Add cached heap items to the scene
    for (int i = 0; i < isHeapItemAddedStack.size(); i++) {
        if (!isHeapItemAddedStack.at(i)) {
            scene->addItem(heap.at(i));
            isHeapItemAddedStack[i] = true;
        }
    }
    for (int i = 0; i < isHeapFrameAddedStack.size(); i++) {
        if (!isHeapFrameAddedStack.at(i)) {
            scene->addItem(heapFrameItemStack.at(i));
            isHeapFrameAddedStack[i] = true;
        }
    }
    
    // Color global/stack/heap items red if they were modified last step
    QList<int> modifiedBytesToBeUpdated = modifiedBytes.toList();
    for (int i = 0; i < bytesWrittenLastStep.size(); i++) {
        if (addressToGlobalItemMap.contains(bytesWrittenLastStep.at(i))) {
            addressToGlobalItemMap.value(bytesWrittenLastStep.at(i))->boxBgColor = Qt::red;
            addressToGlobalItemMap.value(bytesWrittenLastStep.at(i))->boxTextColor = Qt::white;
        }
        if (addressToStackItemMap.contains(bytesWrittenLastStep.at(i))) {
            addressToStackItemMap.value(bytesWrittenLastStep.at(i))->boxBgColor = Qt::red;
            addressToStackItemMap.value(bytesWrittenLastStep.at(i))->boxTextColor = Qt::white;
        }
        if (addressToHeapItemMap.contains(bytesWrittenLastStep.at(i))) {
            addressToHeapItemMap.value(bytesWrittenLastStep.at(i))->boxBgColor = Qt::red;
            addressToHeapItemMap.value(bytesWrittenLastStep.at(i))->boxTextColor = Qt::white;
        }
    }
    // Update modified cells
    for (int i = 0; i < modifiedBytesToBeUpdated.size(); i++) {
        if (addressToGlobalItemMap.contains(modifiedBytesToBeUpdated.at(i))) {
            addressToGlobalItemMap.value(modifiedBytesToBeUpdated.at(i))->updateValue();
        }
        if (addressToStackItemMap.contains(modifiedBytesToBeUpdated.at(i))) {
            addressToStackItemMap.value(modifiedBytesToBeUpdated.at(i))->updateValue();
        }
        if (addressToHeapItemMap.contains(modifiedBytesToBeUpdated.at(i))) {
            addressToHeapItemMap.value(modifiedBytesToBeUpdated.at(i))->updateValue();
        }
    }
    
 
    scene->invalidate(); // redraw the scene!
    // this is fast, so we do this for the whole scene instead of just certain boxes
    
    // Scroll to the top item if we have a scrollbar:
    if (!runtimeStack.isEmpty() && ui->graphicsView->viewport()->height() < scene->height()) {
        ui->graphicsView->centerOn(runtimeStack.top());
    }
    
    // Clear modified bytes so for the next update:
    bytesWrittenLastStep.clear();
    modifiedBytes.clear();
}

 
 
 
 
 
 
 
void MemoryTracePane::cacheChanges()
{
    modifiedBytes.unite(Sim::modifiedBytes);
    if (Sim::tracingTraps) {
        bytesWrittenLastStep.clear();
        bytesWrittenLastStep = Sim::modifiedBytes.toList();
    }
    else if (Sim::trapped) {
        // We delay for a single vonNeumann step so that we preserve the modified bytes until we leave the trap - this allows for
        // recoloring of cells modified by a trap instruction.
        delayLastStepClear = true;
        bytesWrittenLastStep.append(Sim::modifiedBytes.toList());
    }
    else if (delayLastStepClear) {
        // Phew! We can now update (in updateMemoryTrace). If we don't, no harm done - they didn't want to see what happened in the trap
        delayLastStepClear = false;
    }
    else {
        // Clear the bytes written the step before last, and get the new list from the previous step. This is used in our update for coloring.
        bytesWrittenLastStep.clear();
        bytesWrittenLastStep = Sim::modifiedBytes.toList();
    }
    
    // Look ahead for heap/stack changes:
    if (Sim::trapped) {
        return;
    }
    // Look ahead for the symbol trace list (needs to be done here
    // because of the possibility of call (can't look behind on a call)
    // so we just do it for them all)
    switch (Pep::decodeMnemonic[Sim::readByte(Sim::programCounter)]) {
    case Enu::SUBSP:
    case Enu::CALL:
    case Enu::RET:
    case Enu::ADDSP:
        if (Pep::symbolTraceList.contains(Sim::programCounter)) {
        lookAheadSymbolList = Pep::symbolTraceList.value(Sim::programCounter);
    }
    break;
    default:
        break;
    }
    // End look ahead
}

 
 
 
void MemoryTracePane::cacheStackChanges()
{
    if (Sim::trapped) {
        return;
    }
    
    int multiplier = 0;
    int bytesPerCell = 0;
    int offset = 0;
    int numCellsToAdd = 0;
    int frameSizeToAdd = 0;
    QString stackSymbol;
    
    switch (Pep::decodeMnemonic[Sim::instructionSpecifier]) {
    case Enu::CALL:
    {
        MemoryCellGraphicsItem *item = new MemoryCellGraphicsItem(Sim::stackPointer, "retAddr", Enu::F_2H,
            static_cast<int>(stackLocation.x()), static_cast<int>(stackLocation.y()));
        item->updateValue();
        stackLocation.setY(stackLocation.y() - MemoryCellGraphicsItem::boxHeight);
        
        isRuntimeStackItemAddedStack.push(false);
        runtimeStack.push(item);
        addressToStackItemMap.insert(Sim::stackPointer, item);
        frameSizeToAdd = stackFrameFSM.makeTransition(1);
    }
    break;
    case Enu::SUBSP:
    {
        for (int i = 0; i < lookAheadSymbolList.size(); i++) {
            stackSymbol = lookAheadSymbolList.at(i);
            multiplier = Pep::symbolFormatMultiplier.value(stackSymbol);
            if (multiplier == 1) {
                offset += Sim::cellSize(Pep::symbolFormat.value(stackSymbol));
                MemoryCellGraphicsItem *item = new MemoryCellGraphicsItem(Sim::stackPointer - offset + Sim::operandSpecifier,
                stackSymbol,
                Pep::symbolFormat.value(stackSymbol),
                static_cast<int>(stackLocation.x()),
                static_cast<int>(stackLocation.y()));
                item->updateValue();
                stackLocation.setY(stackLocation.y() - MemoryCellGraphicsItem::boxHeight);
                isRuntimeStackItemAddedStack.push(false);
                runtimeStack.push(item);
                addressToStackItemMap.insert(Sim::stackPointer - offset + Sim::operandSpecifier, item);
                numCellsToAdd++;
            }
            else { // This is an array!
                bytesPerCell = Sim::cellSize(Pep::symbolFormat.value(stackSymbol));
                for (int j = multiplier - 1; j >= 0; j--) {
                    offset += bytesPerCell;
                    MemoryCellGraphicsItem *item = new MemoryCellGraphicsItem(Sim::stackPointer - offset + Sim::operandSpecifier,
                        stackSymbol + QString("[%1]").arg(j),
                        Pep::symbolFormat.value(stackSymbol),
                        static_cast<int>(stackLocation.x()),
                        static_cast<int>(stackLocation.y()));
                    item->updateValue();
                    stackLocation.setY(stackLocation.y() - MemoryCellGraphicsItem::boxHeight);
                    isRuntimeStackItemAddedStack.push(false);
                    runtimeStack.push(item);
                    addressToStackItemMap.insert(Sim::stackPointer - offset + Sim::operandSpecifier, item);
                    numCellsToAdd++;
                }
            }
        }
        // qDebug() << "numCellsToAdd before makeTransition in ADDSP: " << numCellsToAdd;
        frameSizeToAdd = stackFrameFSM.makeTransition(numCellsToAdd);
    }
    break;
    case Enu::RET:
    popBytes(2);
    frameSizeToAdd = stackFrameFSM.makeTransition(0); // makeTransition(0) -> 0 bytes to add to the stack frame FSM.
    break;
    case Enu::ADDSP:
    popBytes(Sim::operandSpecifier);
    frameSizeToAdd = stackFrameFSM.makeTransition(0);
    break;
    default:
        frameSizeToAdd = stackFrameFSM.makeTransition(0);
        break;
    }
    
    if (frameSizeToAdd != 0) {
        addStackFrame(frameSizeToAdd);
        // This map is used to correlate the top of the stack frame with the frame itself,
        // useful for determining when the frame should dissapear.
        // IE: The top byte of the frame gets removed, so does the frame
        stackHeightToStackFrameMap.insert(runtimeStack.size() - 1, graphicItemsInStackFrame.top());
    }
}

void MemoryTracePane::cacheHeapChanges()
{
    if (Sim::trapped) {
        return;
    }
    if (ui->warningLabel->text() != "") {
        ui->warningLabel->clear();
    }
    
    if (Pep::decodeMnemonic[Sim::instructionSpecifier] == Enu::CALL && Pep::symbolTable.value("malloc") == Sim::operandSpecifier) {
        newestHeapItemsList.clear();
        int numCellsToAdd = 0;
        int offset = 0;
        int multiplier;
        QString heapSymbol;
        int heapPointer;
        if (Pep::symbolTable.contains("hpPtr")) {
            heapPointer = Pep::symbolTable.value("hpPtr");
        }
        else {
            // We have no idea where the heap pointer is. Error!
            ui->warningLabel->setText("Warning: hpPtr not found, unable to trace <code>CALL \'malloc\'</code>.");
            return;
        }
        int listNumBytes = 0;
        // Check and make sure the accumulator matches the number of bytes we're mallocing:
        // We'll start by adding up the number of bytes...
        for (int i = 0; i < lookAheadSymbolList.size(); i++) {
            heapSymbol = lookAheadSymbolList.at(i);
            if (Pep::equateSymbols.contains(heapSymbol) || Pep::blockSymbols.contains(heapSymbol)) {
                // listNumBytes += number of bytes for that tag * the multiplier (IE, 2d4a is a 4 cell
                // array of 2 byte decimals, where 2 is the multiplier and 4 is the number of cells.
                // Note: the multiplier should always be 1 for malloc'd cells, but that's checked below, where we'll give a more specific error.
                listNumBytes += Asm::tagNumBytes(Pep::symbolFormat.value(heapSymbol)) * Pep::symbolFormatMultiplier.value(heapSymbol);
            }
        }
        if (listNumBytes != Sim::accumulator) {
            ui->warningLabel->setText("Warning: The accumulator doesn't match the number of bytes in the trace tags");
            return;
        }
        for (int i = 0; i < lookAheadSymbolList.size(); i++) {
            heapSymbol = lookAheadSymbolList.at(i);
            if (Pep::equateSymbols.contains(heapSymbol) || Pep::blockSymbols.contains(heapSymbol)) {
                multiplier = Pep::symbolFormatMultiplier.value(heapSymbol);
            }
            else {
                ui->warningLabel->setText("Warning: Symbol \"" + heapSymbol + "\" not found in .equates, unknown size.");
                return;
            }
            if (multiplier == 1) { // We can't support arrays on the stack with our current addressing modes.
                // All our prereqs have been met to make an item
                moveHeapUpOneCell();
                
                MemoryCellGraphicsItem *item = new MemoryCellGraphicsItem(Sim::readWord(heapPointer) + offset,
                    heapSymbol,
                    Pep::symbolFormat.value(heapSymbol),
                    static_cast<int>(heapLocation.x()),
                    static_cast<int>(heapLocation.y()));
                item->updateValue();
                isHeapItemAddedStack.push(false);
                heap.push(item);
                addressToHeapItemMap.insert(Sim::readWord(heapPointer) + offset, item);
                newestHeapItemsList.append(item);
                offset += Sim::cellSize(Pep::symbolFormat.value(heapSymbol));
                numCellsToAdd++;
            }
        }
        if (numCellsToAdd != 0) {
            addHeapFrame(numCellsToAdd);
        }
    }
}



void MemoryTracePane::addStackFrame(int numCells)
{
    QPen pen(Qt::black);
    pen.setWidth(4);
    QGraphicsRectItem *item = new QGraphicsRectItem(stackLocation.x() - 2, stackLocation.y() + MemoryCellGraphicsItem::boxHeight,
        static_cast<qreal>(MemoryCellGraphicsItem::boxWidth + 4),
        static_cast<qreal>(MemoryCellGraphicsItem::boxHeight * numCells), 0);
    item->setPen(pen);
    graphicItemsInStackFrame.push(item);
    isStackFrameAddedStack.push(false);
    item->setZValue(1.0); // This moves the stack frame to the front
    numCellsInStackFrame.push(numCells);
}

void MemoryTracePane::addHeapFrame(int numCells)
{
    QPen pen(Qt::black);
    pen.setWidth(4);
    QGraphicsRectItem *item = new QGraphicsRectItem(heapLocation.x() - 2,
                                                    heapLocation.y() - MemoryCellGraphicsItem::boxHeight * (numCells - 1),
        static_cast<qreal>(MemoryCellGraphicsItem::boxWidth + 4),
        static_cast<qreal>(MemoryCellGraphicsItem::boxHeight * numCells), 0);
    item->setPen(pen);
    heapFrameItemStack.push(item);
    isHeapFrameAddedStack.push(false);
    item->setZValue(1.0); // This moves the heap frame to the front
}

void MemoryTracePane::moveHeapUpOneCell()
{
    for (int i = 0; i < heap.size(); i++) {
        heap.at(i)->moveBy(0, 0 - MemoryCellGraphicsItem::boxHeight);
    }
    for (int i = 0; i < heapFrameItemStack.size(); i++) {
        heapFrameItemStack.at(i)->moveBy(0, 0 - MemoryCellGraphicsItem::boxHeight);
    }
}

void MemoryTracePane::popBytes(int bytesToPop)
{
    while (bytesToPop > 0 && !runtimeStack.isEmpty()) {
        if (stackHeightToStackFrameMap.contains(runtimeStack.size() - 1)) {
            if (stackHeightToStackFrameMap.value(runtimeStack.size() - 1)->scene() == scene) {
                scene->removeItem(stackHeightToStackFrameMap.value(runtimeStack.size() - 1));
            }
            delete stackHeightToStackFrameMap.value(runtimeStack.size() - 1);
            graphicItemsInStackFrame.pop();
            stackHeightToStackFrameMap.remove(runtimeStack.size() - 1);
            isStackFrameAddedStack.pop();
            numCellsInStackFrame.pop();
        }
        
        if (runtimeStack.top()->scene() == scene) {
            scene->removeItem(runtimeStack.top());
        }
        addressToStackItemMap.remove(runtimeStack.top()->getAddress());
        bytesToPop -= runtimeStack.top()->getNumBytes();
        delete runtimeStack.top();
        runtimeStack.pop();
        isRuntimeStackItemAddedStack.pop();
        stackLocation.setY(stackLocation.y() + MemoryCellGraphicsItem::boxHeight);
    }
}
 */
