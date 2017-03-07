//
//  TraceController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class TraceController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Post: The memory trace is populated (on assembly).
    func setMemoryTrace(){}
    
    // Post: The memory trace is updated
    func updateMemoryTrace(){}
    
    // Post: Modfied bytes are cached for updating the sim view
    func cacheChanges(){}
    
    // Post: Stack changes are cached for the next time the simulation view is updated
    func cacheStackChanges(){}
    
    // Post: Heap changes are cached for the next time the simulation view is updated
    func cacheHeapChanges(){}
    
    
    /// Stack of the global variables.
    var globalVars: Stack<MemoryCellGraphicsItem> = Stack()
    /// Stack of the stack items.
    var runtimeStack: Stack<MemoryCellGraphicsItem> = Stack()
    /// Stack of heap items.
    var heap: Stack<MemoryCellGraphicsItem> = Stack()
    
    
//    // Used to keep track if the item has been added to the scene yet for the runtime stack.
//    var isRuntimeStackItemAddedStack: Stack<Bool>
//    // Used to keep track if the item has been added to the scene yet for the heap
//    var isHeapItemAddedStack: Stack<Bool>
//    
    // This is used to give us what we're pushing onto the stack before we get there.
    // It must be a look-ahead list because of branching and the inability to look behind
    var lookAheadSymbolList: [String] = []

    
//    // Stack frame
//    var stackHeightToStackFrameMap: [Int : QGraphicsRectItem]
//    
//    var numCellsInStackFrame: Stack<Int>
//    // This is a stack of ints that each represent how many cells each stack frame encompass
//    var isStackFrameAddedStack: Stack<Bool>
//    // Stack used to determine if a stack frame has been added to the scene yet
//    Stack<QGraphicsRectItem *> graphicItemsInStackFrame
//    // Stack of *items used to access the stack frames
//    Stack<Bool> isHeapFrameAddedStack
//    // Stack used to determine if a heap frame has been added to the scene yet
//    Stack<QGraphicsRectItem *> heapFrameItemStack
//    // Stack of *items for the heap graphic frames
//    
//    var globalLocation: CGPoint!
//    // This is the location where the next global item will be added
//    var stackLocation: CGPoint!
//    // This is the location where the next stack item will be added
//    var heapLocation: CGPoint!
//    // This is the location where the next heap item will be added
//    
//    var addressToGlobalItemMap: [Int : MemoryCellGraphicsItem] = [:]
//    // This map is used to identify if an address is in the globals
//    var addressToStackItemMap: [Int : MemoryCellGraphicsItem] = [:]
//    // This map is used to identify if an address is part of the stack
//    var addressToHeapItemMap: [Int : MemoryCellGraphicsItem] = [:]
//    // Used to identify if an address is part of the heap
//    QSet<int> modifiedBytes
//    // This set is used to cache modified bytes since the last update
//    QList<int> bytesWrittenLastStep
//    // This list is used to keep track of the bytes changed last step for highlighting purposes
//    bool delayLastStepClear
//    // This is used to delay the clear of the bytesWrittenLastStep list for purposes of highlighting after a trap
//    
//    var newestHeapItemsList: [MemoryCellGraphicsItem]
//    // This is used to color the most recently malloc'd heap items light green
//    
//    StackFrameFSM stackFrameFSM
//    
//    // Called by the cacheStack/HeapChanges functions to add frames to the respective places.
//    // They're in their own functions because a fair bit happens there.
//    func addStackFrame(numCells: Int) {
//        
//    }
//    func addHeapFrame(numCells: Int) {
//        
//    }
//    
//    // Moves the heap frame up n cells to accomodate for malloc items being added.
//    func moveHeapUpOneCell() {
//        
//    }
//    
//    func popBytes(bytesToPop: Int) {
//        
//    }
//    // This pops bytesToPop bytes off of the runtimeStack
//    
    
    
}
