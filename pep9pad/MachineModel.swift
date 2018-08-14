//  MachineModel.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//


var machine = MachineModel()

class MachineModel {
    
    /// The simulated machine.

    // MARK: - Properties
    /// Main memory, pre-allocated to 64KiB (== 65536 bytes)
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
    var isTrapped: Bool
    var shouldTraceTraps: Bool

    var isSimulating: Bool
    var shouldHalt: Bool
    
    let maxPositive = 32768
    
    // MARK: - Initializer
    init() {
        nBit = false
        zBit = false
        vBit = false
        cBit = false
        
        accumulator = 0
        indexRegister = 0
        stackPointer = 0
        programCounter = 300
        instructionSpecifier = 0
        operandSpecifier = 0
        operand = 0
        
        inputBuffer = ""
        outputBuffer = ""
        
        modifiedBytes = Set()
        isTrapped = false
        shouldTraceTraps = false
        
        isSimulating = false
        shouldHalt = false
                
    }
    
    
    func stopSimulating() {
        isSimulating = false
        
    }
    
    func interrupt() {
        // TODO
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
        
        nBit = result < maxPositive ? false : true
        zBit = result == 0 ? true : false
        vBit = (lhs < maxPositive && rhs < maxPositive && result >= maxPositive) ||
            (lhs >= maxPositive && rhs >= maxPositive && result < maxPositive)
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
        case .None, .All, .I:
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
        if (memAddr < maps.romStartAddress) {
            mem[memAddr & 0xffff] = value
            modifiedBytes.insert(memAddr & 0xffff)
        }
    }
    
    /// Pre: 0 <= value < 65536
    /// Post: The high-end byte of value is stored in mem[memAddr]
    /// and the low-end byte of value is stored in mem[memAddr + 1]
    func writeWord(memAddr: Int, value: Int) {
        if (memAddr < maps.romStartAddress) {
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
            break // illegal
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
            break // illegal
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
    
    func vonNeumannStep(errorString: inout String) -> Bool {
        modifiedBytes.removeAll()
        var mnemonic: EMnemonic
        var addrMode: EAddrMode
        var temp: Int
        var bTemp: Bool // Changed type from Int to Bool
        // Fetch
        instructionSpecifier = readByte(programCounter)
        // Increment
        programCounter = add(programCounter, 1)
        // Decode
        mnemonic = maps.decodeMnemonic[instructionSpecifier]
        addrMode = maps.decodeAddrMode[instructionSpecifier]
        if (!maps.isUnaryMap[mnemonic]!) {
            operandSpecifier = readWord(programCounter)
            programCounter = add(programCounter, 2)
        }
        
        let isUnary = maps.isUnaryMap[mnemonic]!
        let isTrap = maps.isTrapMap[mnemonic]!
        let addr = maps.addrModesMap[mnemonic]!
        let rawVal = addrMode.rawValue
        let hasCorrectAddrMode = ( addr & rawVal ).toBool()
        
        if (!isUnary && !isTrap && !hasCorrectAddrMode) {
            print (errorString) // MARK: Return Tuple
            return false
        }
        
        
        switch (maps.decodeMnemonic[instructionSpecifier]) {
        case .ADDA:
            operand = readWordOprnd(addrMode: addrMode)
            accumulator = addAndSetNZVC(accumulator, operand)
            return true
        case .ADDX:
            operand = readWordOprnd(addrMode: addrMode)
            indexRegister = addAndSetNZVC(indexRegister, operand)
            return true
        case .ADDSP:
            operand = readWordOprnd(addrMode: addrMode)
            stackPointer = add(stackPointer, operand)
            return true
        case .ANDA:
            operand = readWordOprnd(addrMode: addrMode)
            accumulator = accumulator & operand
            nBit = accumulator > maxPositive // TODO: why not >= ?
            zBit = accumulator == 0
            return true
        case .ANDX:
            operand = readWordOprnd(addrMode: addrMode)
            indexRegister = indexRegister & operand
            nBit = indexRegister > maxPositive
            zBit = indexRegister == 0
            return true
        case .ASLA:
            let hasPrefix01 = accumulator >= 0x4000 && accumulator < 0x8000
            let hasPrefix10 = accumulator >= 0x8000 && accumulator < 0xC000
            vBit = hasPrefix01 || hasPrefix10
            accumulator *= 2 // shift left
            if accumulator >= 65536 {
                cBit = true
                accumulator = accumulator & 0xffff
            } else {
                cBit = false
            }
            nBit = accumulator >= maxPositive
            zBit = accumulator == 0
            return true
        case .ASLX:
            let hasPrefix01 = indexRegister >= 0x4000 && indexRegister < 0x8000
            let hasPrefix10 = indexRegister >= 0x8000 && indexRegister < 0xC000
            vBit = hasPrefix01 || hasPrefix10
            indexRegister *= 2 // shift left
            if (indexRegister >= 65536) {
                cBit = true
                indexRegister = indexRegister & 0xffff
            }
            else {
                cBit = false
            }
            nBit = indexRegister >= maxPositive
            zBit = indexRegister == 0
            return true
        case .ASRA:
            cBit = (accumulator % 2) == 1
            if accumulator < maxPositive {
                accumulator /= 2 // shift right
            } else {
                accumulator = accumulator / 2 + maxPositive
            }
            nBit = accumulator >= maxPositive
            zBit = accumulator == 0
            return true
        case .ASRX:
            cBit = (indexRegister % 2) == 1
            if indexRegister < maxPositive {
                indexRegister /= 2 // shift right
            } else {
                indexRegister = indexRegister / 2 + maxPositive
            }
            nBit = indexRegister >= maxPositive
            zBit = indexRegister == 0
            return true
        case .BR:
            operand = readWordOprnd(addrMode: addrMode)
            programCounter = operand
            return true
        case .BRC:
            operand = readWordOprnd(addrMode: addrMode)
            if cBit {
                programCounter = operand
            }
            return true
        case .BREQ:
            operand = readWordOprnd(addrMode: addrMode)
            if zBit {
                programCounter = operand
            }
            return true
        case .BRGE:
            operand = readWordOprnd(addrMode: addrMode)
            if !nBit {
                programCounter = operand
            }
            return true
        case .BRGT:
            operand = readWordOprnd(addrMode: addrMode)
            if !nBit && !zBit {
                programCounter = operand
            }
            return true
        case .BRLE:
            operand = readWordOprnd(addrMode: addrMode)
            if nBit || zBit {
                programCounter = operand
            }
            return true
        case .BRLT:
            operand = readWordOprnd(addrMode: addrMode)
            if nBit {
                programCounter = operand
            }
            return true
        case .BRNE:
            operand = readWordOprnd(addrMode: addrMode)
            if !zBit {
                programCounter = operand
            }
            return true
        case .BRV:
            operand = readWordOprnd(addrMode: addrMode)
            if vBit {
                programCounter = operand
            }
            return true
        case .CALL:
            operand = readWordOprnd(addrMode: addrMode)
            stackPointer = add(stackPointer, 65534) // SP <- SP-2
            writeWord(memAddr: stackPointer, value: programCounter) // Mem[SP] <- PC
            programCounter = operand // PC <- Oprnd
            return true
        case .CPBA:
            operand = readByteOprnd(addrMode: addrMode)
            temp = (accumulator & 0x00ff) - operand
            nBit = temp < 0
            zBit = temp == 0
            vBit = false
            cBit = false
            return true
        case .CPBX:
            operand = readByteOprnd(addrMode: addrMode)
            temp = (indexRegister & 0x00ff) - operand
            nBit = temp < 0
            zBit = temp == 0
            vBit = false
            cBit = false
            return true
        case .CPWA:
            operand = readWordOprnd(addrMode: addrMode)
            addAndSetNZVC(accumulator, (~operand + 1) & 0xffff)
            if vBit {
                // Extend compare range. nBit and zBit are not adjusted in subtract instructions.
                nBit = !nBit
            }
            return true
        case .CPWX:
            operand = readWordOprnd(addrMode: addrMode)
            addAndSetNZVC(indexRegister, (~operand + 1) & 0xffff)
            if vBit {
                // Extend compare range. nBit and zBit are not adjusted in subtract instructions.
                nBit = !nBit
            }
            return true
        case .DECI,.DECO,.HEXO,.STRO,.NOP,.NOP0,.NOP1:
            // trap instructions
            let loc = maps.dotBurnArgument - 9
            temp = readWord(loc)
            // 9 is the vector offset from the last byte of the OS for the System stack pointer
            writeByte(memAddr: temp - 1, value: instructionSpecifier)
            writeWord(memAddr: temp - 3, value: stackPointer)
            writeWord(memAddr: temp - 5, value: programCounter)
            writeWord(memAddr: temp - 7, value: indexRegister)
            writeWord(memAddr: temp - 9, value: accumulator)
            writeByte(memAddr: temp - 10, value: nzvcToInt())
            stackPointer = temp - 10
            programCounter = readWord(maps.dotBurnArgument - 1)
            indexRegister = 0 // compensating for bug in PEP9 OS, this is also done in the desktop version.
            return true
        case .LDBA:
            if (addrMode != .I && addrOfByteOprnd(addrMode: addrMode) == 256 * mem[maps.dotBurnArgument - 7] + mem[maps.dotBurnArgument - 6]) {
                // Memory-mapped input
                if inputBuffer != "" {
                    var ch: Character = inputBuffer.characters.removeFirst()
                    operand = Int(ch.asciiValue!) // TODO: Hash value? or toLatin1?
                    operand += operand < 0 ? 256 : 0
                } else {
                    // Attempt to read past end of input
                    // Only happens with batch input
                    operand = 0
                }
            } else {
                operand = readByteOprnd(addrMode: addrMode)
            }
            accumulator = accumulator & 0xff00
            accumulator |= operand & 255
            nBit = false
            zBit = operand == 0
            return true
        case .LDBX:
            if (addrMode != .I && addrOfByteOprnd(addrMode: addrMode) == 256 * mem[maps.dotBurnArgument - 7] + mem[maps.dotBurnArgument - 6]) {
                // Memory-mapped input
                if (inputBuffer != "") {
                    var ch: Character = inputBuffer.characters.removeFirst()
                    operand = Int(ch.asciiValue!) // TODO: Hash value? or toLatin1?
                    operand += operand < 0 ? 256 : 0
                } else {
                    // Attempt to read past end of input
                    // Only happens with batch input
                    operand = 0
                }
            } else {
                operand = readByteOprnd(addrMode: addrMode)
            }
            indexRegister = indexRegister & 0xff00
            indexRegister |= operand & 255
            nBit = false
            zBit = operand == 0
            return true
        case .LDWA:
            operand = readWordOprnd(addrMode: addrMode)
            accumulator = operand & 0xffff
            nBit = accumulator >= maxPositive
            zBit = accumulator == 0
            return true
        case .LDWX:
            operand = readWordOprnd(addrMode: addrMode)
            indexRegister = operand & 0xffff
            nBit = indexRegister >= maxPositive
            zBit = indexRegister == 0
            return true
        case .MOVAFLG:
            cBit = (accumulator & 0x0001) != 0
            vBit = (accumulator & 0x0002) != 0
            zBit = (accumulator & 0x0004) != 0
            nBit = (accumulator & 0x0008) != 0
            return true
        case .MOVFLGA:
            accumulator = accumulator & 0xff00
            accumulator |= cBit ? 1 : 0
            accumulator |= vBit ? 2 : 0
            accumulator |= zBit ? 4 : 0
            accumulator |= nBit ? 8 : 0
            return true
        case .MOVSPA:
            accumulator = stackPointer
            return true
        case .NEGA:
            accumulator = (~accumulator + 1) & 0xffff
            nBit = accumulator >= maxPositive
            zBit = accumulator == 0
            vBit = accumulator == maxPositive
            return true
        case .NEGX:
            indexRegister = (~indexRegister + 1) & 0xffff
            nBit = accumulator >= maxPositive
            zBit = accumulator == 0
            vBit = accumulator == maxPositive
            return true
        case .NOTA:
            accumulator = ~accumulator & 0xffff
            nBit = accumulator >= maxPositive
            zBit = accumulator == 0
            return true
        case .NOTX:
            indexRegister = ~indexRegister & 0xffff
            nBit = indexRegister >= maxPositive
            zBit = indexRegister == 0
            return true
        case .ORA:
            operand = readWordOprnd(addrMode: addrMode)
            accumulator = accumulator | operand
            nBit = accumulator > maxPositive
            zBit = accumulator == 0
            return true
        case .ORX:
            operand = readWordOprnd(addrMode: addrMode)
            indexRegister = indexRegister | operand
            nBit = indexRegister > maxPositive
            zBit = indexRegister == 0
            return true
        case .RET:
            programCounter = readWord(stackPointer) // PC <- Mem[SP]
            stackPointer = add(stackPointer, 2) // SP <- SP + 2
            return true
        case .RETTR:
            temp = readByte(stackPointer)
            nBit = (temp & 8) != 0
            zBit = (temp & 4) != 0
            vBit = (temp & 2) != 0
            cBit = (temp & 1) != 0
            accumulator = readWord(stackPointer + 1)
            indexRegister = readWord(stackPointer + 3)
            programCounter = readWord(stackPointer + 5)
            stackPointer = readWord(stackPointer + 7)
            return true
        case .ROLA:
            bTemp = accumulator >= maxPositive
            accumulator = (accumulator * 2) & 0xffff
            accumulator |= cBit ? 1 : 0
            cBit = bTemp
            return true
        case .ROLX:
            bTemp = indexRegister >= maxPositive
            indexRegister = (indexRegister * 2) & 0xffff
            indexRegister |= cBit ? 1 : 0
            cBit = bTemp
            return true
        case .RORA:
            bTemp = accumulator % 2 == 1
            accumulator = (accumulator / 2)
            accumulator |= cBit ? 0x8000 : 0
            cBit = bTemp
            return true
        case .RORX:
            bTemp = indexRegister % 2 == 1
            indexRegister = (indexRegister / 2)
            indexRegister |= cBit ? 0x8000 : 0
            cBit = bTemp
            return true
        case .STBA:
            operand = accumulator & 0x00ff
            if (addrOfByteOprnd(addrMode: addrMode) == 256 * mem[maps.dotBurnArgument - 5] + mem[maps.dotBurnArgument - 4]) {
                // Memory-mapped output
                outputBuffer.append(operand.toASCII())
            } else {
                writeByteOprnd(addrMode: addrMode, value: operand)
            }
            return true
        case .STBX:
            operand = indexRegister & 0x00ff
            if (addrOfByteOprnd(addrMode: addrMode) == 256 * mem[maps.dotBurnArgument - 5] + mem[maps.dotBurnArgument - 4]) {
                // Memory-mapped output
                outputBuffer.append(operand.toASCII())
            } else {
                writeByteOprnd(addrMode: addrMode, value: operand)
            }
            return true
        case .STWA:
            writeWordOprnd(addrMode: addrMode, value: accumulator)
            operand = readWordOprnd(addrMode: addrMode)
            return true
        case .STWX:
            writeWordOprnd(addrMode: addrMode, value: indexRegister)
            operand = readWordOprnd(addrMode: addrMode)
            return true
        case .STOP:
            return true
        case .SUBA:
            operand = readWordOprnd(addrMode: addrMode)
            accumulator = addAndSetNZVC(accumulator, (~operand + 1) & 0xffff)
            return true
        case .SUBX:
            operand = readWordOprnd(addrMode: addrMode)
            indexRegister = addAndSetNZVC(indexRegister, (~operand + 1) & 0xffff)
            return true
        case .SUBSP:
            operand = readWordOprnd(addrMode: addrMode)
            stackPointer = add(stackPointer, (~operand + 1) & 0xffff)
            return true
        default:
            // should not happen
            return false
        }
        return false
    }
    
    
    
    // I wrote this function to make the ProcessorController update() method a bit more elegant. Now that I'm thinking about it, this might be an inappropriate method for the MachineModel.
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
    
    /// Determines whether or not the charIn trap will be used.
    func willAccessCharIn() -> Bool {
        var instrSpecTemp = readByte(programCounter)
        var mnemonTemp = maps.decodeMnemonic[instrSpecTemp]
        
        if (mnemonTemp != .LDBA && mnemonTemp != .LDBX) {
            return false
        }
        var addrModeTemp = maps.decodeAddrMode[instrSpecTemp]
        if addrModeTemp == .I {
            return false
        }
        
        var oprndSpecTemp = readWord(add(programCounter, 1))
        var addrOfByteOprndTemp = 0
        switch addrModeTemp {
        case .None, .All, .I:
            break
        case .D:
            addrOfByteOprndTemp = operandSpecifier
        case .N:
            addrOfByteOprndTemp = readWord(operandSpecifier)
        case .S:
            addrOfByteOprndTemp = add(stackPointer, operandSpecifier)
        case .SF:
            addrOfByteOprndTemp = readWord(add(stackPointer, operandSpecifier))
        case .X:
            addrOfByteOprndTemp = add(operandSpecifier, indexRegister)
        case .SX:
            addrOfByteOprndTemp = add(add(stackPointer, operandSpecifier), indexRegister)
        case .SFX:
            addrOfByteOprndTemp = add(readWord(add(stackPointer, operandSpecifier)), indexRegister)
        }
        
        let val = 256 * mem[maps.dotBurnArgument - 7] + mem[maps.dotBurnArgument - 6]
        return val == addrOfByteOprndTemp

    }
    
    
    
    func trapLookahead() {
        // if the instruction under the PC is a trap...
        if maps.isTrapMap[maps.decodeMnemonic[readByte(programCounter)]]! {
            isTrapped = true
            //maps.memAddrssToAssemblerListing = maps.memAddrssToAssemblerListingOS
            //maps.listingRowChecked = maps.listingRowCheckedOS
        // otherwise if we are returning from a trap
        } else if maps.decodeMnemonic[readByte(programCounter)] == .RETTR {
            isTrapped = false
            //maps.memAddrssToAssemblerListing = maps.memAddrssToAssemblerListingProg
            //maps.listingRowChecked = maps.listingRowCheckedProg
        }
    }
    
    
    
    
    
}
