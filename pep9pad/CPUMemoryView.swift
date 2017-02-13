//
//  CPUMemoryView.swift
//  pep9pad
//
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

class CPUMemoryView: MemoryView {
    
    
    var rows: [String] = []
    var highlightedIndex: Int
    var currentMemoryOffset: Int
    var mem: [Character] //     initialized in c++ as char mem[0x10000];
    var 
    
    /// Populates the table.
    func populateMemoryItems() {
        
    }
    
    /// Refreshes the memory to reflect the model.
    func refreshMemory() {
        
    }
    
    
    func setMemAddress(memAddress: Int, value: Int) {
        
    }
    
    func setMemPrecondition(memAddress: Int, value: Int) {
        
    }
    
    func testMemPostcondition(memAddress: Int, value: Int) {
        
    }
    
    /// Sets all memory to 0x00.
    func clearMemory() {
        
    }
    /// Scrolls to modified cell and highlights it.
    func showMemEdited(address: Int) {
        
    }
    
    /// Highlights all modified bytes in the current view.
    func highlightModifiedBytes() {
        
    }

    /// Scrolls to the given address.  Used to display the recently modified code.
    func scrollToAddress(address: Int) {
        
    }
    
    
}
