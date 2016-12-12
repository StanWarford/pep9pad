//
//  StackFrameFSM.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

class StackFrameFSM {
    
    var state: StackState = .start
    
    /// number of cells from the first SUBSP (i.e. parameters and retVal)
    var numCellsFromSubSP: Int = 0
    var numCellsFromCall: Int = 0
    
    
    /// if the frame is ready to add, return the number of cells -- otherwise return 0
    func makeTransition(numCellsToAdd: Int) -> Int {
        let mnemon: EMnemonic = maps.decodeMnemonic[machine.instructionSpecifier]
    
        switch state {
        case .start:
            if (mnemon == .SUBSP) {
                numCellsFromSubSP = numCellsToAdd
                state = .subSP
            } else if (mnemon == .CALL) {
                numCellsFromSubSP = 0
                numCellsFromCall = 1 // = numCellsToAdd // ECall = 1
                state = .call
            }
            break
            
        case .subSP:
            if (mnemon == .CALL) {
                numCellsFromCall = 1 // = numCellsToAdd
                state = .call
            } else { // not .call
                state = .start
                return numCellsFromSubSP // lone subsp
            }
            break
            
        case .call:
            if (mnemon == .SUBSP) { // function with 1 or more locals and 0 or more parameters
                state = .start
                return (numCellsFromSubSP + numCellsFromCall + numCellsToAdd)
            } else { // not .subSP
                state = .start // no locals
                return (numCellsFromSubSP + numCellsFromCall)
            }
        }
        
        return 0 // don't add a frame yet
    }
    
    /// set everything to 0 and start state
    func reset() {
        state = .start
        numCellsFromSubSP = 0
        numCellsFromCall = 0
    }

}
