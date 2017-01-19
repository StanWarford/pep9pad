//  MachineModel.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//


var machine = MachineModel()

/// The simulated machine.
class MachineModel {
    
    
    // MARK: - Properties
    /// Main memory, pre-allocated
    var mem: [Int] = [Int](repeating: 0, count: 65536)
    
    // MARK: CPU
    var nBit, zBit, vBit, cBit: Bool
    var accumulator: Int
    var indexRegister: Int
    var stackPointer: Int
    var programCounter: Int
    var instructionSpecifier: Int
    var operandSpecifier: Int
    var operand: Int
    
    var inputBuffer: String
    var outputBuffer: String
    
    var modifiedBytes: Set<Int>
    var trapped: Bool
    var tracingTraps: Bool
    
    
    /// .BURN and the ROM State
    var romStartAddress: Int
    
    /// State for keeping track of what actions are possible for user and machine.  Unused in Pep9.
    //var executionState: EExecState
    
    
    // MARK: - Initializer
    init() {
        nBit = false
        zBit = false
        vBit = false
        cBit = false
        
        accumulator = 0
        indexRegister = 0
        stackPointer = 0
        programCounter = 0
        instructionSpecifier = 0
        operandSpecifier = 0
        operand = 0
        
        inputBuffer = ""
        outputBuffer = ""
        
        modifiedBytes = Set()
        trapped = false
        tracingTraps = false
        
        romStartAddress = 0
        
    }
    
    /// Pre: 0 <= value < 65536
    /// Post: -32768 <= value < 32768 is returned
    func toSignedDecimal(_ value: Int) -> Int {
        return value > 32767 ? value - 65536 : value
    }
    
    /// Pre: -32768 <= value < 32768
    /// Post: 0 <= value < 65536 is returned
    func fromSignedDecimal(_ value: Int) -> Int {
        return value < 0 ? value + 65536 : value
    }
    
    /// Post: NZVC is returned in postions <4..7> of the one-byte int
    func nzvcToInt() -> Int {
        var i: Int = 0
        if (nBit) { i = i | 8 }
        if (zBit) { i = i | 4 }
        if (vBit) { i = i | 2 }
        if (cBit) { i = i | 1 }
        return i
    }
    
    func add(_ lhs: Int, _ rhs: Int) -> Int {
        return (lhs + rhs) & 0xffff
    }
    
    func addAndSetNZVC(_ lhs: Int, _ rhs: Int) -> Int {
        var result = lhs + rhs
        
        if (result >= 65536) {
            cBit = true
            result = result & 0xffff
        } else {
            cBit = false
        }
        
        nBit = result < 32768 ? false : true
        zBit = result == 0 ? true : false
        vBit = (lhs < 32768 && rhs < 32768 && result >= 32768) ||
                    (lhs >= 32768 && rhs >= 32768 && result < 32768)
        return result
    }
    
    func loadMem(_ objectCode: [Int]) {
        var objectCode = objectCode
        var i = 0
        while objectCode.count > 0 {
            mem[i] = objectCode.removeFirst()
            i += 1
        }
    }
    
    
    
    
    // MARK: Methods for Reading from Memory
    
    func readByte(_ addr: Int) -> Int {
        return mem[addr & 0xffff]
    }
    
    func readWord(_ addr: Int) -> Int {
        return 256 * mem[addr & 0xffff] + mem[(addr + 1) & 0xffff]
    }
    
    // Pre: addrMode cannot be immediate.
    func addrOfByteOprnd(addrMode: EAddrMode) -> Int {
        switch addrMode {
        case .None, .All:
            break
        case .I:
            break
        case .D:
            return operandSpecifier
        case .N:
            return readWord(operandSpecifier)
        case .S:
            return add(stackPointer, operandSpecifier)
        case .SF:
            return readWord(add(stackPointer, operandSpecifier))
        case .X:
            return add(operandSpecifier, indexRegister)
        case .SX:
            return add(add(stackPointer, operandSpecifier), indexRegister)
        case .SFX:
            return add(readWord(add(stackPointer, operandSpecifier)), indexRegister)
        }
        
        return 0
    }
    
    func readByteOprnd(addrMode: EAddrMode) -> Int {
        switch addrMode {
        case .None, .All:
            break
        case .I:
            return operandSpecifier
        case .D:
            return readByte(operandSpecifier)
        case .N:
            return readByte(readWord(operandSpecifier))
        case .S:
            return readByte(add(stackPointer, operandSpecifier))
        case .SF:
            return readByte(readWord(add(stackPointer, operandSpecifier)))
        case .X:
            return readByte(add(operandSpecifier, indexRegister))
        case .SX:
            return readByte(add(add(stackPointer, operandSpecifier), indexRegister))
        case .SFX:
            return readByte(add(readWord(add(stackPointer, operandSpecifier)), indexRegister))
        }
        return 0
    }
    
    func readWordOprnd(addrMode: EAddrMode) -> Int {
        switch addrMode {
        case .None, .All:
            break
        case .I:
            return operandSpecifier
        case .D:
            return readWord(operandSpecifier)
        case .N:
            return readWord(readWord(operandSpecifier))
        case .S:
            return readWord(add(stackPointer, operandSpecifier))
        case .SF:
            return readWord(readWord(add(stackPointer, operandSpecifier)))
        case .X:
            return readWord(add(operandSpecifier, indexRegister))
        case .SX:
            return readWord(add(add(stackPointer, operandSpecifier), indexRegister))
        case .SFX:
            return readWord(add(readWord(add(stackPointer, operandSpecifier)), indexRegister))
        }
        return 0
    }
    
    
    
    
    // MARK: Methods for Writing to Memory
    
    /// Pre: 0 <= value < 256
    /// Post: Value is stored in mem[addr]
    func writeByte(memAddr: Int, value: Int) {
        // TODO  
        if (memAddr < romStartAddress) {
        mem[memAddr & 0xffff] = value
        modifiedBytes.insert(memAddr & 0xffff)
    }
    
    /// Pre: 0 <= value < 65536
    /// Post: The high-end byte of value is stored in mem[memAddr]
    /// and the low-end byte of value is stored in mem[memAddr + 1]
    func writeWord(memAddr: Int, value: Int) {
        // TODO
        if (memAddr < romStartAddress) {
            mem[memAddr & 0xffff] = value / 256
            mem[(memAddr + 1) & 0xffff] = value % 256
            modifiedBytes.insert(memAddr & 0xffff)
            modifiedBytes.insert((memAddr + 1) & 0xffff)
        }
    }
    
    func writeByteOprnd(addrMode: EAddrMode, value: Int) {
        switch (addrMode) {
        case .None, .All:
            break
        case .I:
            // illegal
            break
        case .D:
            writeByte(memAddr: operandSpecifier, value: value)
        case .N:
            writeByte(memAddr: readWord(operandSpecifier), value: value)
        case .S:
            writeByte(memAddr: add(stackPointer, operandSpecifier), value: value)
        case .SF:
            writeByte(memAddr: readWord(add(stackPointer, operandSpecifier)), value: value)
        case .X:
            writeByte(memAddr: add(operandSpecifier, indexRegister), value: value)
        case .SX:
            writeByte(memAddr: add(add(stackPointer, operandSpecifier), indexRegister), value: value)
        case .SFX:
            writeByte(memAddr: add(readWord(add(stackPointer, operandSpecifier)), indexRegister), value: value)
        }
    }
    
    func writeWordOprnd(addrMode: EAddrMode, value: Int) {
        switch (addrMode) {
        case .None, .All:
            break
        case .I:
            // illegal
            break
        case .D:
            writeWord(memAddr: operandSpecifier, value: value)
        case .N:
            writeWord(memAddr: readWord(operandSpecifier), value: value)
        case .S:
            writeWord(memAddr: add(stackPointer, operandSpecifier), value: value)
        case .SF:
            writeWord(memAddr: readWord(add(stackPointer, operandSpecifier)), value: value)
        case .X:
            writeWord(memAddr: add(operandSpecifier, indexRegister), value: value)
        case .SX:
            writeWord(memAddr: add(add(stackPointer, operandSpecifier), indexRegister), value: value)
        case .SFX:
            writeWord(memAddr: add(readWord(add(stackPointer, operandSpecifier)), indexRegister), value: value)
        }
    }
    
    func cellSize(symbolFormat: ESymbolFormat) -> Int {
        switch symbolFormat {
        case .F_1C:
            return 1
        case .F_1D:
            return 1
        case .F_2D:
            return 2
        case .F_1H:
            return 1
        case .F_2H:
            return 2
        default:
            // Should not occur
            assert(false)
            return 0
        }
    }
    
    func vonNeumannStep(errorString: String) -> Bool {
        // TODO
        return true
    }
    
    
    
    // I wrote this function to make the CpuController update() method a bit more elegant. Now that I'm thinking about it, this might be an inappropriate method for the MachineModel.  
    func prettyVersion(_ register: CPURegisters, format: CPUFormats) -> String {
        var value = 0
        
        // get the value of the field
        switch register {
        case .nBit, .zBit, .vBit, .cBit:
            return ""
        case .accumulator:
            value = accumulator
        case .indexRegister:
            value = indexRegister
        case .stackPointer:
            value = stackPointer
        case .programCounter:
            value = programCounter
        case .instructionSpecifier:
            value = instructionSpecifier
        case .operandSpecifier:
            value = operandSpecifier
        case .operand:
            value = operand
        }
        
        // format
        switch format {
        case .bin:
            return value.toBin8()
        case .hex:
            return "0x\(value.toHex4())"
        case .dec:
            return "\(toSignedDecimal(value))"
        case .mnemon:
            return " " + maps.enumToMnemonMap[maps.decodeMnemonic[instructionSpecifier]]! + maps.commaSpaceStringForAddrMode(addressMode: maps.decodeAddrMode[instructionSpecifier])
            
            
        }
        
        
    }
    
    
}
}
