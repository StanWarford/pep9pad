//
//  PepMaps.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

var maps = PepMaps()

class PepMaps {
    // Default redefine mnemonics
    let defaultUnaryMnemonic0: String = "NOP0"
    let defaultUnaryMnemonic1: String = "NOP1"
    let defaultNonUnaryMnemonic0: String = "NOP"
    let defaultMnemon0i: Bool = true
    let defaultMnemon0d: Bool = false
    let defaultMnemon0n: Bool = false
    let defaultMnemon0s: Bool = false
    let defaultMnemon0sf: Bool = false
    let defaultMnemon0x: Bool = false
    let defaultMnemon0sx: Bool = false
    let defaultMnemon0sfx: Bool = false
    let defaultNonUnaryMnemonic1: String = "DECI"
    let defaultMnemon1i: Bool = false
    let defaultMnemon1d: Bool = true
    let defaultMnemon1n: Bool = true
    let defaultMnemon1s: Bool = true
    let defaultMnemon1sf: Bool = true
    let defaultMnemon1x: Bool = true
    let defaultMnemon1sx: Bool = true
    let defaultMnemon1sfx: Bool = true
    let defaultNonUnaryMnemonic2: String = "DECO"
    let defaultMnemon2i: Bool = true
    let defaultMnemon2d: Bool = true
    let defaultMnemon2n: Bool = true
    let defaultMnemon2s: Bool = true
    let defaultMnemon2sf: Bool = true
    let defaultMnemon2x: Bool = true
    let defaultMnemon2sx: Bool = true
    let defaultMnemon2sfx: Bool = true
    let defaultNonUnaryMnemonic3: String = "HEXO"
    let defaultMnemon3i: Bool = true
    let defaultMnemon3d: Bool = true
    let defaultMnemon3n: Bool = true
    let defaultMnemon3s: Bool = true
    let defaultMnemon3sf: Bool = true
    let defaultMnemon3x: Bool = true
    let defaultMnemon3sx: Bool = true
    let defaultMnemon3sfx: Bool = true
    let defaultNonUnaryMnemonic4: String = "STRO"
    let defaultMnemon4i: Bool = false
    let defaultMnemon4d: Bool = true
    let defaultMnemon4n: Bool = true
    let defaultMnemon4s: Bool = true
    let defaultMnemon4sf: Bool = true
    let defaultMnemon4x: Bool = true
    let defaultMnemon4sx: Bool = false
    let defaultMnemon4sfx: Bool = false
    
    
    // Functions for computing instruction specifiers
    func aaaAddressField(addressMode: EAddrMode) -> Int {
        if (addressMode == .I) { return 0 }
        if (addressMode == .D) { return 1 }
        if (addressMode == .N) { return 2 }
        if (addressMode == .S) { return 3 }
        if (addressMode == .SF) { return 4 }
        if (addressMode == .X) { return 5 }
        if (addressMode == .SX) { return 6 }
        if (addressMode == .SFX) { return 7 }
        assert(false)
        return -1; // Should not occur
    }
    func aAddressField(addressMode: EAddrMode) -> Int {
        if (addressMode == .I) { return 0 }
        if (addressMode == .X) { return 1 }
        assert(false)
        return -1; // Should not occur
    }
    
    
    func stringForAddrMode(addressMode: EAddrMode) -> String {
        if (addressMode == .None) { return "" }
        if (addressMode == .I) { return "i" }
        if (addressMode == .D) { return "d" }
        if (addressMode == .N) { return "n" }
        if (addressMode == .S) { return "s" }
        if (addressMode == .SF) { return "sf" }
        if (addressMode == .X) { return "x" }
        if (addressMode == .SX) { return "sx" }
        if (addressMode == .SFX) { return "sfx" }
        assert(false)
        return ""; // Should not occur
    }
    
    
    func commaSpaceStringForAddrMode(addressMode: EAddrMode) -> String {
        if (addressMode == .None) { return "" }
        if (addressMode == .I) { return ", i" }
        if (addressMode == .D) { return ", d" }
        if (addressMode == .N) { return ", n" }
        if (addressMode == .S) { return ", s" }
        if (addressMode == .SF) { return ", sf" }
        if (addressMode == .X) { return ", x" }
        if (addressMode == .SX) { return ", sx" }
        if (addressMode == .SFX) { return ", sfx" }
        assert(false)
        return ""; // Should not occur
    }

    // Maps between mnemonic enums and strings.
    // Initialized with `initEnumMnemonMaps()`.
    var enumToMnemonMap: [EMnemonic:String] = [:]
    var mnemonToEnumMap: [String:EMnemonic] = [:]
    
    // Maps to characterize each instruction.
    // Initialized with `initMnemonicMaps()`.
    var opCodeMap: [EMnemonic:Int] = [:]
    var isUnaryMap: [EMnemonic:Bool] = [:]
    var addrModeRequiredMap: [EMnemonic:Bool] = [:]
    var isTrapMap: [EMnemonic:Bool] = [:]
    
    
    // Map to specify legal addressing modes for each instruction.
    // Initialized with initAddrModesMap().
    var addrModesMap: [EMnemonic:Int] = [:]

    // The symbol table
    var symbolTable: [String:Int] = [:]
    var adjustSymbolValueForBurn: [String:Bool] = [:]
    
    // The trace tag tables
    var symbolFormat: [String:ESymbolFormat] = [:]
    var symbolFormatMultiplier: [String:Int] = [:]
    
    // This map is for global structs. The key is the symbol defined on the .BLOCK line
    // and [String] contains the list of symbols from the symbol tags in the .BLOCK comment.
    var globalStructSymbols: [String:[String]] = [:]
    
    // This map is used to map the program counter to the stringList of tags on the corresponding line
    // For example:line corresponds to 0x12 and has the comment: Allocate #next #data
    // The [String] would contain next and data
    var symbolTraceList: [Int:[String]] = [:]
    
    var blockSymbols: [String] = []
    var equateSymbols: [String] = []
    
    // Map from instruction memory address to assembler listing line
    // These pointers are set to the addresses of the program or OS maps
    // depending on whether the program or OS is being assembled
    var memAddrssToAssemblerListing: [Int:Int] = [:]
    var listingRowChecked: [Int:Bool] = [:]
    
    var memAddrssToAssemblerListingProg: [Int:Int] = [:]
    var listingRowCheckedProg: [Int:Bool] = [:]
    
    var memAddrssToAssemblerListingOS: [Int:Int] = [:]
    var listingRowCheckedOS: [Int:Bool] = [:]
    
    // Decoder tables, initialized with `initDecoderTables()`.
    // Both have 255 values.
    var decodeMnemonic: [EMnemonic] = []
    var decodeAddrMode: [EAddrMode] = []

    
    /// The number of bytes occupied by the assembled source.
    var byteCount: Int = 0
    /// The number of .BURN directives found in the source.
    var burnCount: Int = 0
    /// The argument of the .BURN command. Defaults to 0xFFFF (65535).
    /// Can think of it as the end of ROM.
    var dotBurnArgument: Int = 0
    /// The beginning of ROM, equal to dotBurnArgument minus size of OS.
    var romStartAddress: Int = 0
    
    /// This is true iff the assembled source contains an errant trace tag.
    var traceTagWarning: Bool = false
    
    
    
    // MARK: - Initializers
    
    // Init for entire class
    init() {
        initAddrModesMap()
        initMnemonicMaps()
        initDecoderTables()
        initEnumMnemonMaps()
    }
    
    
    func initAddrModesMap() {
        
        //let None = 0
        let I = 1
        let D = 2
        let N = 4
        let S = 8
        let SF = 16
        let X = 32
        let SX = 64
        let SFX = 128
        let All = 255
        
        // Nonunary instructions
        addrModesMap[.ADDA] = All
        addrModesMap[.ADDX] = All
        addrModesMap[.ADDSP] = All
        addrModesMap[.ANDA] = All
        addrModesMap[.ANDX] = All
        addrModesMap[.BR] = I | X
        addrModesMap[.BRC] = I | X
        addrModesMap[.BREQ] = I | X
        addrModesMap[.BRGE] = I | X
        addrModesMap[.BRGT] = I | X
        addrModesMap[.BRLE] = I | X
        addrModesMap[.BRLT] = I | X
        addrModesMap[.BRNE] = I | X
        addrModesMap[.BRV] = I | X
        addrModesMap[.CALL] = I | X
        addrModesMap[.CPBA] = All
        addrModesMap[.CPBX] = All
        addrModesMap[.CPWA] = All
        addrModesMap[.CPWX] = All
        addrModesMap[.LDBA] = All
        addrModesMap[.LDBX] = All
        addrModesMap[.LDWA] = All
        addrModesMap[.LDWX] = All
        addrModesMap[.ORA] = All
        addrModesMap[.ORX] = All
        addrModesMap[.STBA] = D | N | S | SF | X | SX | SFX
        addrModesMap[.STBX] = D | N | S | SF | X | SX | SFX
        addrModesMap[.STWA] = D | N | S | SF | X | SX | SFX
        addrModesMap[.STWX] = D | N | S | SF | X | SX | SFX
        addrModesMap[.SUBA] = All
        addrModesMap[.SUBX] = All
        addrModesMap[.SUBSP] = All
        
        // Nonunary trap instructions
        var addrMode: Int = 0;
        if (defaultMnemon0i) { addrMode |= I }
        if (defaultMnemon0d) { addrMode |= D }
        if (defaultMnemon0n) { addrMode |= N }
        if (defaultMnemon0s) { addrMode |= S }
        if (defaultMnemon0sf) { addrMode |= SF }
        if (defaultMnemon0x) { addrMode |= X }
        if (defaultMnemon0sx) { addrMode |= SX }
        if (defaultMnemon0sfx) { addrMode |= SFX }
        addrModesMap[.NOP] = addrMode
        addrMode = 0
        if (defaultMnemon1i) { addrMode |= I }
        if (defaultMnemon1d) { addrMode |= D }
        if (defaultMnemon1n) { addrMode |= N }
        if (defaultMnemon1s) { addrMode |= S }
        if (defaultMnemon1sf) { addrMode |= SF }
        if (defaultMnemon1x) { addrMode |= X }
        if (defaultMnemon1sx) { addrMode |= SX }
        if (defaultMnemon1sfx) { addrMode |= SFX }
        addrModesMap[.DECI] = addrMode
        addrMode = 0
        if (defaultMnemon2i) { addrMode |= I }
        if (defaultMnemon2d) { addrMode |= D }
        if (defaultMnemon2n) { addrMode |= N }
        if (defaultMnemon2s) { addrMode |= S }
        if (defaultMnemon2sf) { addrMode |= SF }
        if (defaultMnemon2x) { addrMode |= X }
        if (defaultMnemon2sx) { addrMode |= SX }
        if (defaultMnemon2sfx) { addrMode |= SFX }
        addrModesMap[.DECO] = addrMode
        addrMode = 0
        if (defaultMnemon3i) { addrMode |= I }
        if (defaultMnemon3d) { addrMode |= D }
        if (defaultMnemon3n) { addrMode |= N }
        if (defaultMnemon3s) { addrMode |= S }
        if (defaultMnemon3sf) { addrMode |= SF }
        if (defaultMnemon3x) { addrMode |= X }
        if (defaultMnemon3sx) { addrMode |= SX }
        if (defaultMnemon3sfx) { addrMode |= SFX }
        addrModesMap[.HEXO] = addrMode
        addrMode = 0
        if (defaultMnemon3i) { addrMode |= I }
        if (defaultMnemon3d) { addrMode |= D }
        if (defaultMnemon3n) { addrMode |= N }
        if (defaultMnemon3s) { addrMode |= S }
        if (defaultMnemon3sf) { addrMode |= SF }
        if (defaultMnemon3x) { addrMode |= X }
        if (defaultMnemon3sx) { addrMode |= SX }
        if (defaultMnemon3sfx) { addrMode |= SFX }
        addrModesMap[.STRO] = addrMode
    }
    
    func initEnumMnemonMaps() {
        // Can be called from Redefine Mnemonics, so we must clear first.
        enumToMnemonMap.removeAll(); mnemonToEnumMap.removeAll();
        enumToMnemonMap[.ADDA] = "ADDA"; mnemonToEnumMap["ADDA"] = .ADDA;
        enumToMnemonMap[.ADDX] = "ADDX"; mnemonToEnumMap["ADDX"] = .ADDX;
        enumToMnemonMap[.ADDSP] = "ADDSP"; mnemonToEnumMap["ADDSP"] = .ADDSP;
        enumToMnemonMap[.ANDA] = "ANDA"; mnemonToEnumMap["ANDA"] = .ANDA;
        enumToMnemonMap[.ANDX] = "ANDX"; mnemonToEnumMap["ANDX"] = .ANDX;
        enumToMnemonMap[.ASLA] = "ASLA"; mnemonToEnumMap["ASLA"] = .ASLA;
        enumToMnemonMap[.ASLX] = "ASLX"; mnemonToEnumMap["ASLX"] = .ASLX;
        enumToMnemonMap[.ASRA] = "ASRA"; mnemonToEnumMap["ASRA"] = .ASRA;
        enumToMnemonMap[.ASRX] = "ASRX"; mnemonToEnumMap["ASRX"] = .ASRX;
        enumToMnemonMap[.BR] = "BR"; mnemonToEnumMap["BR"] = .BR;
        enumToMnemonMap[.BRC] = "BRC"; mnemonToEnumMap["BRC"] = .BRC;
        enumToMnemonMap[.BREQ] = "BREQ"; mnemonToEnumMap["BREQ"] = .BREQ;
        enumToMnemonMap[.BRGE] = "BRGE"; mnemonToEnumMap["BRGE"] = .BRGE;
        enumToMnemonMap[.BRGT] = "BRGT"; mnemonToEnumMap["BRGT"] = .BRGT;
        enumToMnemonMap[.BRLE] = "BRLE"; mnemonToEnumMap["BRLE"] = .BRLE;
        enumToMnemonMap[.BRLT] = "BRLT"; mnemonToEnumMap["BRLT"] = .BRLT;
        enumToMnemonMap[.BRNE] = "BRNE"; mnemonToEnumMap["BRNE"] = . BRNE;
        enumToMnemonMap[.BRV] = "BRV"; mnemonToEnumMap["BRV"] = .BRV;
        enumToMnemonMap[.CALL] = "CALL"; mnemonToEnumMap["CALL"] = .CALL;
        enumToMnemonMap[.CPBA] = "CPBA"; mnemonToEnumMap["CPBA"] = .CPBA;
        enumToMnemonMap[.CPBX] = "CPBX"; mnemonToEnumMap["CPBX"] = .CPBX;
        enumToMnemonMap[.CPWA] = "CPWA"; mnemonToEnumMap["CPWA"] = .CPWA;
        enumToMnemonMap[.CPWX] = "CPWX"; mnemonToEnumMap["CPWX"] = .CPWX;
        enumToMnemonMap[.DECI] = defaultNonUnaryMnemonic1; mnemonToEnumMap[defaultNonUnaryMnemonic1] = .DECI;
        enumToMnemonMap[.DECO] = defaultNonUnaryMnemonic2; mnemonToEnumMap[defaultNonUnaryMnemonic2] = .DECO;
        enumToMnemonMap[.HEXO] = defaultNonUnaryMnemonic3; mnemonToEnumMap[defaultNonUnaryMnemonic3] = .HEXO;
        enumToMnemonMap[.LDBA] = "LDBA"; mnemonToEnumMap["LDBA"] = .LDBA;
        enumToMnemonMap[.LDWA] = "LDWA"; mnemonToEnumMap["LDWA"] = .LDWA;
        enumToMnemonMap[.LDBX] = "LDBX"; mnemonToEnumMap["LDBX"] = .LDBX;
        enumToMnemonMap[.LDWX] = "LDWX"; mnemonToEnumMap["LDWX"] = .LDWX;
        enumToMnemonMap[.MOVAFLG] = "MOVAFLG"; mnemonToEnumMap["MOVAFLG"] = .MOVAFLG;
        enumToMnemonMap[.MOVFLGA] = "MOVFLGA"; mnemonToEnumMap["MOVFLGA"] = .MOVFLGA;
        enumToMnemonMap[.MOVSPA] = "MOVSPA"; mnemonToEnumMap["MOVSPA"] = .MOVSPA;
        enumToMnemonMap[.NEGA] = "NEGA"; mnemonToEnumMap["NEGA"] = .NEGA;
        enumToMnemonMap[.NEGX] = "NEGX"; mnemonToEnumMap["NEGX"] = .NEGX;
        enumToMnemonMap[.NOP] = defaultNonUnaryMnemonic0; mnemonToEnumMap[defaultNonUnaryMnemonic0] = .NOP;
        enumToMnemonMap[.NOP0] = defaultUnaryMnemonic0; mnemonToEnumMap[defaultUnaryMnemonic0] = .NOP0;
        enumToMnemonMap[.NOP1] = defaultUnaryMnemonic1; mnemonToEnumMap[defaultUnaryMnemonic1] = .NOP1;
        enumToMnemonMap[.NOTA] = "NOTA"; mnemonToEnumMap["NOTA"] = .NOTA;
        enumToMnemonMap[.NOTX] = "NOTX"; mnemonToEnumMap["NOTX"] = .NOTX;
        enumToMnemonMap[.ORA] = "ORA"; mnemonToEnumMap["ORA"] = .ORA;
        enumToMnemonMap[.ORX] = "ORX"; mnemonToEnumMap["ORX"] = .ORX;
        enumToMnemonMap[.RET] = "RET"; mnemonToEnumMap["RET"] = .RET;
        enumToMnemonMap[.RETTR] = "RETTR"; mnemonToEnumMap["RETTR"] = .RETTR;
        enumToMnemonMap[.ROLA] = "ROLA"; mnemonToEnumMap["ROLA"] = .ROLA;
        enumToMnemonMap[.ROLX] = "ROLX"; mnemonToEnumMap["ROLX"] = .ROLX;
        enumToMnemonMap[.RORA] = "RORA"; mnemonToEnumMap["RORA"] = .RORA;
        enumToMnemonMap[.RORX] = "RORX"; mnemonToEnumMap["RORX"] = .RORX;
        enumToMnemonMap[.STBA] = "STBA"; mnemonToEnumMap["STBA"] = .STBA;
        enumToMnemonMap[.STBX] = "STBX"; mnemonToEnumMap["STBX"] = .STBX;
        enumToMnemonMap[.STWA] = "STWA"; mnemonToEnumMap["STWA"] = .STWA;
        enumToMnemonMap[.STWX] = "STWX"; mnemonToEnumMap["STWX"] = .STWX;
        enumToMnemonMap[.STOP] = "STOP"; mnemonToEnumMap["STOP"] = .STOP;
        enumToMnemonMap[.STRO] = defaultNonUnaryMnemonic4; mnemonToEnumMap[defaultNonUnaryMnemonic4] = .STRO;
        enumToMnemonMap[.SUBA] = "SUBA"; mnemonToEnumMap["SUBA"] = .SUBA;
        enumToMnemonMap[.SUBX] = "SUBX"; mnemonToEnumMap["SUBX"] = .SUBX;
        enumToMnemonMap[.SUBSP] = "SUBSP"; mnemonToEnumMap["SUBSP"] = .SUBSP;
    }
    
    func initMnemonicMaps() {
        opCodeMap[.ADDA] = 96; isUnaryMap[.ADDA] = false; addrModeRequiredMap[.ADDA] = true; isTrapMap[.ADDA] = false;
        opCodeMap[.ADDX] = 104; isUnaryMap[.ADDX] = false; addrModeRequiredMap[.ADDX] = true; isTrapMap[.ADDX] = false;
        opCodeMap[.ADDSP] = 80; isUnaryMap[.ADDSP] = false; addrModeRequiredMap[.ADDSP] = true; isTrapMap[.ADDSP] = false;
        opCodeMap[.ANDA] = 128; isUnaryMap[.ANDA] = false; addrModeRequiredMap[.ANDA] = true; isTrapMap[.ANDA] = false;
        opCodeMap[.ANDX] = 136; isUnaryMap[.ANDX] = false; addrModeRequiredMap[.ANDX] = true; isTrapMap[.ANDX] = false;
        opCodeMap[.ASLA] = 10; isUnaryMap[.ASLA] = true; addrModeRequiredMap[.ASLA] = true; isTrapMap[.ASLA] = false;
        opCodeMap[.ASLX] = 11; isUnaryMap[.ASLX] = true; addrModeRequiredMap[.ASLX] = true; isTrapMap[.ASLX] = false;
        opCodeMap[.ASRA] = 12; isUnaryMap[.ASRA] = true; addrModeRequiredMap[.ASRA] = true; isTrapMap[.ASRA] = false;
        opCodeMap[.ASRX] = 13; isUnaryMap[.ASRX] = true; addrModeRequiredMap[.ASRX] = true; isTrapMap[.ASRX] = false;
        
        opCodeMap[.BR] = 18; isUnaryMap[.BR] = false; addrModeRequiredMap[.BR] = false; isTrapMap[.BR] = false;
        opCodeMap[.BRC] = 34; isUnaryMap[.BRC] = false; addrModeRequiredMap[.BRC] = false; isTrapMap[.BRC] = false;
        opCodeMap[.BREQ] = 24; isUnaryMap[.BREQ] = false; addrModeRequiredMap[.BREQ] = false; isTrapMap[.BREQ] = false;
        opCodeMap[.BRGE] = 28; isUnaryMap[.BRGE] = false; addrModeRequiredMap[.BRGE] = false; isTrapMap[.BRGE] = false;
        opCodeMap[.BRGT] = 30; isUnaryMap[.BRGT] = false; addrModeRequiredMap[.BRGT] = false; isTrapMap[.BRGT] = false;
        opCodeMap[.BRLE] = 20; isUnaryMap[.BRLE] = false; addrModeRequiredMap[.BRLE] = false; isTrapMap[.BRLE] = false;
        opCodeMap[.BRLT] = 22; isUnaryMap[.BRLT] = false; addrModeRequiredMap[.BRLT] = false; isTrapMap[.BRLT] = false;
        opCodeMap[.BRNE] = 26; isUnaryMap[.BRNE] = false; addrModeRequiredMap[.BRNE] = false; isTrapMap[.BRNE] = false;
        opCodeMap[.BRV] = 32; isUnaryMap[.BRV] = false; addrModeRequiredMap[.BRV] = false; isTrapMap[.BRV] = false;
        
        opCodeMap[.CALL] = 36; isUnaryMap[.CALL] = false; addrModeRequiredMap[.CALL] = false; isTrapMap[.CALL] = false;
        opCodeMap[.CPBA] = 176; isUnaryMap[.CPBA] = false; addrModeRequiredMap[.CPBA] = true; isTrapMap[.CPBA] = false;
        opCodeMap[.CPBX] = 184; isUnaryMap[.CPBX] = false; addrModeRequiredMap[.CPBX] = true; isTrapMap[.CPBX] = false;
        opCodeMap[.CPWA] = 160; isUnaryMap[.CPWA] = false; addrModeRequiredMap[.CPWA] = true; isTrapMap[.CPWA] = false;
        opCodeMap[.CPWX] = 168; isUnaryMap[.CPWX] = false; addrModeRequiredMap[.CPWX] = true; isTrapMap[.CPWX] = false;
        
        opCodeMap[.DECI] = 48; isUnaryMap[.DECI] = false; addrModeRequiredMap[.DECI] = true; isTrapMap[.DECI] = true;
        opCodeMap[.DECO] = 56; isUnaryMap[.DECO] = false; addrModeRequiredMap[.DECO] = true; isTrapMap[.DECO] = true;
        
        opCodeMap[.HEXO] = 64; isUnaryMap[.HEXO] = false; addrModeRequiredMap[.HEXO] = true; isTrapMap[.HEXO] = true;
        
        opCodeMap[.LDBA] = 208; isUnaryMap[.LDBA] = false; addrModeRequiredMap[.LDBA] = true; isTrapMap[.LDBA] = false;
        opCodeMap[.LDBX] = 216; isUnaryMap[.LDBX] = false; addrModeRequiredMap[.LDBX] = true; isTrapMap[.LDBX] = false;
        opCodeMap[.LDWA] = 192; isUnaryMap[.LDWA] = false; addrModeRequiredMap[.LDWA] = true; isTrapMap[.LDWA] = false;
        opCodeMap[.LDWX] = 200; isUnaryMap[.LDWX] = false; addrModeRequiredMap[.LDWX] = true; isTrapMap[.LDWX] = false;
        
        opCodeMap[.MOVAFLG] = 5; isUnaryMap[.MOVAFLG] = true; addrModeRequiredMap[.MOVAFLG] = true; isTrapMap[.MOVAFLG] = false;
        opCodeMap[.MOVFLGA] = 4; isUnaryMap[.MOVFLGA] = true; addrModeRequiredMap[.MOVFLGA] = true; isTrapMap[.MOVFLGA] = false;
        opCodeMap[.MOVSPA] = 3; isUnaryMap[.MOVSPA] = true; addrModeRequiredMap[.MOVSPA] = true; isTrapMap[.MOVSPA] = false;
        
        opCodeMap[.NEGA] = 8; isUnaryMap[.NEGA] = true; addrModeRequiredMap[.NEGA] = true; isTrapMap[.NEGA] = false;
        opCodeMap[.NEGX] = 9; isUnaryMap[.NEGX] = true; addrModeRequiredMap[.NEGX] = true; isTrapMap[.NEGX] = false;
        opCodeMap[.NOP] = 40; isUnaryMap[.NOP] = false; addrModeRequiredMap[.NOP] = true; isTrapMap[.NOP] = true;
        opCodeMap[.NOP0] = 38; isUnaryMap[.NOP0] = true; addrModeRequiredMap[.NOP0] = true; isTrapMap[.NOP0] = true;
        opCodeMap[.NOP1] = 39; isUnaryMap[.NOP1] = true; addrModeRequiredMap[.NOP1] = true; isTrapMap[.NOP1] = true;
        opCodeMap[.NOTA] = 6; isUnaryMap[.NOTA] = true; addrModeRequiredMap[.NOTA] = true; isTrapMap[.NOTA] = false;
        opCodeMap[.NOTX] = 7; isUnaryMap[.NOTX] = true; addrModeRequiredMap[.NOTX] = true; isTrapMap[.NOTX] = false;
        
        opCodeMap[.ORA] = 144; isUnaryMap[.ORA] = false; addrModeRequiredMap[.ORA] = true; isTrapMap[.ORA] = false;
        opCodeMap[.ORX] = 152; isUnaryMap[.ORX] = false; addrModeRequiredMap[.ORX] = true; isTrapMap[.ORX] = false;
        
        opCodeMap[.RET] = 1; isUnaryMap[.RET] = true; addrModeRequiredMap[.RET] = true; isTrapMap[.RET] = false;
        opCodeMap[.RETTR] = 2; isUnaryMap[.RETTR] = true; addrModeRequiredMap[.RETTR] = true; isTrapMap[.RETTR] = false;
        opCodeMap[.ROLA] = 14; isUnaryMap[.ROLA] = true; addrModeRequiredMap[.ROLA] = true; isTrapMap[.ROLA] = false;
        opCodeMap[.ROLX] = 15; isUnaryMap[.ROLX] = true; addrModeRequiredMap[.ROLX] = true; isTrapMap[.ROLX] = false;
        opCodeMap[.RORA] = 16; isUnaryMap[.RORA] = true; addrModeRequiredMap[.RORA] = true; isTrapMap[.RORA] = false;
        opCodeMap[.RORX] = 17; isUnaryMap[.RORX] = true; addrModeRequiredMap[.RORX] = true; isTrapMap[.RORX] = false;
        
        opCodeMap[.STBA] = 240; isUnaryMap[.STBA] = false; addrModeRequiredMap[.STBA] = true; isTrapMap[.STBA] = false;
        opCodeMap[.STBX] = 248; isUnaryMap[.STBX] = false; addrModeRequiredMap[.STBX] = true; isTrapMap[.STBX] = false;
        opCodeMap[.STWA] = 224; isUnaryMap[.STWA] = false; addrModeRequiredMap[.STWA] = true; isTrapMap[.STWA] = false;
        opCodeMap[.STWX] = 232; isUnaryMap[.STWX] = false; addrModeRequiredMap[.STWX] = true; isTrapMap[.STWX] = false;
        opCodeMap[.STOP] = 0; isUnaryMap[.STOP] = true; addrModeRequiredMap[.STOP] = true; isTrapMap[.STOP] = false;
        opCodeMap[.STRO] = 72; isUnaryMap[.STRO] = false; addrModeRequiredMap[.STRO] = true; isTrapMap[.STRO] = true;
        opCodeMap[.SUBA] = 112; isUnaryMap[.SUBA] = false; addrModeRequiredMap[.SUBA] = true; isTrapMap[.SUBA] = false;
        opCodeMap[.SUBX] = 120; isUnaryMap[.SUBX] = false; addrModeRequiredMap[.SUBX] = true; isTrapMap[.SUBX] = false;
        opCodeMap[.SUBSP] = 88; isUnaryMap[.SUBSP] = false; addrModeRequiredMap[.SUBSP] = true; isTrapMap[.SUBSP] = false;
    }
    
    func initDecoderTables() {
        
        for _ in 0..<256 {
            decodeMnemonic.append(.NOP)
            decodeAddrMode.append(.None)
        }
        
        decodeMnemonic[0] = .STOP; decodeAddrMode[0] = .None;
        decodeMnemonic[1] = .RET; decodeAddrMode[1] = .None;
        decodeMnemonic[2] = .RETTR; decodeAddrMode[2] = .None;
        decodeMnemonic[3] = .MOVSPA; decodeAddrMode[3] = .None;
        decodeMnemonic[4] = .MOVFLGA; decodeAddrMode[4] = .None;
        decodeMnemonic[5] = .MOVAFLG; decodeAddrMode[5] = .None;
        
        decodeMnemonic[6] = .NOTA; decodeAddrMode[6] = .None;
        decodeMnemonic[7] = .NOTX; decodeAddrMode[7] = .None;
        decodeMnemonic[8] = .NEGA; decodeAddrMode[8] = .None;
        decodeMnemonic[9] = .NEGX; decodeAddrMode[9] = .None;
        decodeMnemonic[10] = .ASLA; decodeAddrMode[10] = .None;
        decodeMnemonic[11] = .ASLX; decodeAddrMode[11] = .None;
        decodeMnemonic[12] = .ASRA; decodeAddrMode[12] = .None;
        decodeMnemonic[13] = .ASRX; decodeAddrMode[13] = .None;
        decodeMnemonic[14] = .ROLA; decodeAddrMode[14] = .None;
        decodeMnemonic[15] = .ROLX; decodeAddrMode[15] = .None;
        decodeMnemonic[16] = .RORA; decodeAddrMode[16] = .None;
        decodeMnemonic[17] = .RORX; decodeAddrMode[17] = .None;
        
        decodeMnemonic[18] = .BR; decodeAddrMode[18] = .I;
        decodeMnemonic[19] = .BR; decodeAddrMode[19] = .X;
        decodeMnemonic[20] = .BRLE; decodeAddrMode[20] = .I;
        decodeMnemonic[21] = .BRLE; decodeAddrMode[21] = .X;
        decodeMnemonic[22] = .BRLT; decodeAddrMode[22] = .I;
        decodeMnemonic[23] = .BRLT; decodeAddrMode[23] = .X;
        decodeMnemonic[24] = .BREQ; decodeAddrMode[24] = .I;
        decodeMnemonic[25] = .BREQ; decodeAddrMode[25] = .X;
        decodeMnemonic[26] = .BRNE; decodeAddrMode[26] = .I;
        decodeMnemonic[27] = .BRNE; decodeAddrMode[27] = .X;
        decodeMnemonic[28] = .BRGE; decodeAddrMode[28] = .I;
        decodeMnemonic[29] = .BRGE; decodeAddrMode[29] = .X;
        decodeMnemonic[30] = .BRGT; decodeAddrMode[30] = .I;
        decodeMnemonic[31] = .BRGT; decodeAddrMode[31] = .X;
        decodeMnemonic[32] = .BRV; decodeAddrMode[32] = .I;
        decodeMnemonic[33] = .BRV; decodeAddrMode[33] = .X;
        decodeMnemonic[34] = .BRC; decodeAddrMode[34] = .I;
        decodeMnemonic[35] = .BRC; decodeAddrMode[35] = .X;
        decodeMnemonic[36] = .CALL; decodeAddrMode[36] = .I;
        decodeMnemonic[37] = .CALL; decodeAddrMode[37] = .X;
        
        // Note that the trap instructions are all unary at the machine level
        decodeMnemonic[38] = .NOP0; decodeAddrMode[38] = .None;
        decodeMnemonic[39] = .NOP1; decodeAddrMode[39] = .None;
        
        decodeMnemonic[40] = .NOP; decodeAddrMode[40] = .None;
        decodeMnemonic[41] = .NOP; decodeAddrMode[41] = .None;
        decodeMnemonic[42] = .NOP; decodeAddrMode[42] = .None;
        decodeMnemonic[43] = .NOP; decodeAddrMode[43] = .None;
        decodeMnemonic[44] = .NOP; decodeAddrMode[44] = .None;
        decodeMnemonic[45] = .NOP; decodeAddrMode[45] = .None;
        decodeMnemonic[46] = .NOP; decodeAddrMode[46] = .None;
        decodeMnemonic[47] = .NOP; decodeAddrMode[47] = .None;
        
        decodeMnemonic[48] = .DECI; decodeAddrMode[48] = .None;
        decodeMnemonic[49] = .DECI; decodeAddrMode[49] = .None;
        decodeMnemonic[50] = .DECI; decodeAddrMode[50] = .None;
        decodeMnemonic[51] = .DECI; decodeAddrMode[51] = .None;
        decodeMnemonic[52] = .DECI; decodeAddrMode[52] = .None;
        decodeMnemonic[53] = .DECI; decodeAddrMode[53] = .None;
        decodeMnemonic[54] = .DECI; decodeAddrMode[54] = .None;
        decodeMnemonic[55] = .DECI; decodeAddrMode[55] = .None;
        
        decodeMnemonic[56] = .DECO; decodeAddrMode[56] = .None;
        decodeMnemonic[57] = .DECO; decodeAddrMode[57] = .None;
        decodeMnemonic[58] = .DECO; decodeAddrMode[58] = .None;
        decodeMnemonic[59] = .DECO; decodeAddrMode[59] = .None;
        decodeMnemonic[60] = .DECO; decodeAddrMode[60] = .None;
        decodeMnemonic[61] = .DECO; decodeAddrMode[61] = .None;
        decodeMnemonic[62] = .DECO; decodeAddrMode[62] = .None;
        decodeMnemonic[63] = .DECO; decodeAddrMode[63] = .None;
        
        decodeMnemonic[64] = .HEXO; decodeAddrMode[64] = .None;
        decodeMnemonic[65] = .HEXO; decodeAddrMode[65] = .None;
        decodeMnemonic[66] = .HEXO; decodeAddrMode[66] = .None;
        decodeMnemonic[67] = .HEXO; decodeAddrMode[67] = .None;
        decodeMnemonic[68] = .HEXO; decodeAddrMode[68] = .None;
        decodeMnemonic[69] = .HEXO; decodeAddrMode[69] = .None;
        decodeMnemonic[70] = .HEXO; decodeAddrMode[70] = .None;
        decodeMnemonic[71] = .HEXO; decodeAddrMode[71] = .None;
        
        decodeMnemonic[72] = .STRO; decodeAddrMode[72] = .None;
        decodeMnemonic[73] = .STRO; decodeAddrMode[73] = .None;
        decodeMnemonic[74] = .STRO; decodeAddrMode[74] = .None;
        decodeMnemonic[75] = .STRO; decodeAddrMode[75] = .None;
        decodeMnemonic[76] = .STRO; decodeAddrMode[76] = .None;
        decodeMnemonic[77] = .STRO; decodeAddrMode[77] = .None;
        decodeMnemonic[78] = .STRO; decodeAddrMode[78] = .None;
        decodeMnemonic[79] = .STRO; decodeAddrMode[79] = .None;
        
        decodeMnemonic[80] = .ADDSP; decodeAddrMode[80] = .I;
        decodeMnemonic[81] = .ADDSP; decodeAddrMode[81] = .D;
        decodeMnemonic[82] = .ADDSP; decodeAddrMode[82] = .N;
        decodeMnemonic[83] = .ADDSP; decodeAddrMode[83] = .S;
        decodeMnemonic[84] = .ADDSP; decodeAddrMode[84] = .SF;
        decodeMnemonic[85] = .ADDSP; decodeAddrMode[85] = .X;
        decodeMnemonic[86] = .ADDSP; decodeAddrMode[86] = .SX;
        decodeMnemonic[87] = .ADDSP; decodeAddrMode[87] = .SFX;
        
        decodeMnemonic[88] = .SUBSP; decodeAddrMode[88] = .I;
        decodeMnemonic[89] = .SUBSP; decodeAddrMode[89] = .D;
        decodeMnemonic[90] = .SUBSP; decodeAddrMode[90] = .N;
        decodeMnemonic[91] = .SUBSP; decodeAddrMode[91] = .S;
        decodeMnemonic[92] = .SUBSP; decodeAddrMode[92] = .SF;
        decodeMnemonic[93] = .SUBSP; decodeAddrMode[93] = .X;
        decodeMnemonic[94] = .SUBSP; decodeAddrMode[94] = .SX;
        decodeMnemonic[95] = .SUBSP; decodeAddrMode[95] = .SFX;
        
        decodeMnemonic[96] = .ADDA; decodeAddrMode[96] = .I;
        decodeMnemonic[97] = .ADDA; decodeAddrMode[97] = .D;
        decodeMnemonic[98] = .ADDA; decodeAddrMode[98] = .N;
        decodeMnemonic[99] = .ADDA; decodeAddrMode[99] = .S;
        decodeMnemonic[100] = .ADDA; decodeAddrMode[100] = .SF;
        decodeMnemonic[101] = .ADDA; decodeAddrMode[101] = .X;
        decodeMnemonic[102] = .ADDA; decodeAddrMode[102] = .SX;
        decodeMnemonic[103] = .ADDA; decodeAddrMode[103] = .SFX;
        
        decodeMnemonic[104] = .ADDX; decodeAddrMode[104] = .I;
        decodeMnemonic[105] = .ADDX; decodeAddrMode[105] = .D;
        decodeMnemonic[106] = .ADDX; decodeAddrMode[106] = .N;
        decodeMnemonic[107] = .ADDX; decodeAddrMode[107] = .S;
        decodeMnemonic[108] = .ADDX; decodeAddrMode[108] = .SF;
        decodeMnemonic[109] = .ADDX; decodeAddrMode[109] = .X;
        decodeMnemonic[110] = .ADDX; decodeAddrMode[110] = .SX;
        decodeMnemonic[111] = .ADDX; decodeAddrMode[111] = .SFX;
        
        decodeMnemonic[112] = .SUBA; decodeAddrMode[112] = .I;
        decodeMnemonic[113] = .SUBA; decodeAddrMode[113] = .D;
        decodeMnemonic[114] = .SUBA; decodeAddrMode[114] = .N;
        decodeMnemonic[115] = .SUBA; decodeAddrMode[115] = .S;
        decodeMnemonic[116] = .SUBA; decodeAddrMode[116] = .SF;
        decodeMnemonic[117] = .SUBA; decodeAddrMode[117] = .X;
        decodeMnemonic[118] = .SUBA; decodeAddrMode[118] = .SX;
        decodeMnemonic[119] = .SUBA; decodeAddrMode[119] = .SFX;
        
        decodeMnemonic[120] = .SUBX; decodeAddrMode[120] = .I;
        decodeMnemonic[121] = .SUBX; decodeAddrMode[121] = .D;
        decodeMnemonic[122] = .SUBX; decodeAddrMode[122] = .N;
        decodeMnemonic[123] = .SUBX; decodeAddrMode[123] = .S;
        decodeMnemonic[124] = .SUBX; decodeAddrMode[124] = .SF;
        decodeMnemonic[125] = .SUBX; decodeAddrMode[125] = .X;
        decodeMnemonic[126] = .SUBX; decodeAddrMode[126] = .SX;
        decodeMnemonic[127] = .SUBX; decodeAddrMode[127] = .SFX;
        
        decodeMnemonic[128] = .ANDA; decodeAddrMode[128] = .I;
        decodeMnemonic[129] = .ANDA; decodeAddrMode[129] = .D;
        decodeMnemonic[130] = .ANDA; decodeAddrMode[130] = .N;
        decodeMnemonic[131] = .ANDA; decodeAddrMode[131] = .S;
        decodeMnemonic[132] = .ANDA; decodeAddrMode[132] = .SF;
        decodeMnemonic[133] = .ANDA; decodeAddrMode[133] = .X;
        decodeMnemonic[134] = .ANDA; decodeAddrMode[134] = .SX;
        decodeMnemonic[135] = .ANDA; decodeAddrMode[135] = .SFX;
        
        decodeMnemonic[136] = .ANDX; decodeAddrMode[136] = .I;
        decodeMnemonic[137] = .ANDX; decodeAddrMode[137] = .D;
        decodeMnemonic[138] = .ANDX; decodeAddrMode[138] = .N;
        decodeMnemonic[139] = .ANDX; decodeAddrMode[139] = .S;
        decodeMnemonic[140] = .ANDX; decodeAddrMode[140] = .SF;
        decodeMnemonic[141] = .ANDX; decodeAddrMode[141] = .X;
        decodeMnemonic[142] = .ANDX; decodeAddrMode[142] = .SX;
        decodeMnemonic[143] = .ANDX; decodeAddrMode[143] = .SFX;
        
        decodeMnemonic[144] = .ORA; decodeAddrMode[144] = .I;
        decodeMnemonic[145] = .ORA; decodeAddrMode[145] = .D;
        decodeMnemonic[146] = .ORA; decodeAddrMode[146] = .N;
        decodeMnemonic[147] = .ORA; decodeAddrMode[147] = .S;
        decodeMnemonic[148] = .ORA; decodeAddrMode[148] = .SF;
        decodeMnemonic[149] = .ORA; decodeAddrMode[149] = .X;
        decodeMnemonic[150] = .ORA; decodeAddrMode[150] = .SX;
        decodeMnemonic[151] = .ORA; decodeAddrMode[151] = .SFX;
        
        decodeMnemonic[152] = .ORX; decodeAddrMode[152] = .I;
        decodeMnemonic[153] = .ORX; decodeAddrMode[153] = .D;
        decodeMnemonic[154] = .ORX; decodeAddrMode[154] = .N;
        decodeMnemonic[155] = .ORX; decodeAddrMode[155] = .S;
        decodeMnemonic[156] = .ORX; decodeAddrMode[156] = .SF;
        decodeMnemonic[157] = .ORX; decodeAddrMode[157] = .X;
        decodeMnemonic[158] = .ORX; decodeAddrMode[158] = .SX;
        decodeMnemonic[159] = .ORX; decodeAddrMode[159] = .SFX;
        
        decodeMnemonic[160] = .CPWA; decodeAddrMode[160] = .I;
        decodeMnemonic[161] = .CPWA; decodeAddrMode[161] = .D;
        decodeMnemonic[162] = .CPWA; decodeAddrMode[162] = .N;
        decodeMnemonic[163] = .CPWA; decodeAddrMode[163] = .S;
        decodeMnemonic[164] = .CPWA; decodeAddrMode[164] = .SF;
        decodeMnemonic[165] = .CPWA; decodeAddrMode[165] = .X;
        decodeMnemonic[166] = .CPWA; decodeAddrMode[166] = .SX;
        decodeMnemonic[167] = .CPWA; decodeAddrMode[167] = .SFX;
        
        decodeMnemonic[168] = .CPWX; decodeAddrMode[168] = .I;
        decodeMnemonic[169] = .CPWX; decodeAddrMode[169] = .D;
        decodeMnemonic[170] = .CPWX; decodeAddrMode[170] = .N;
        decodeMnemonic[171] = .CPWX; decodeAddrMode[171] = .S;
        decodeMnemonic[172] = .CPWX; decodeAddrMode[172] = .SF;
        decodeMnemonic[173] = .CPWX; decodeAddrMode[173] = .X;
        decodeMnemonic[174] = .CPWX; decodeAddrMode[174] = .SX;
        decodeMnemonic[175] = .CPWX; decodeAddrMode[175] = .SFX;
        
        decodeMnemonic[176] = .CPBA; decodeAddrMode[176] = .I;
        decodeMnemonic[177] = .CPBA; decodeAddrMode[177] = .D;
        decodeMnemonic[178] = .CPBA; decodeAddrMode[178] = .N;
        decodeMnemonic[179] = .CPBA; decodeAddrMode[179] = .S;
        decodeMnemonic[180] = .CPBA; decodeAddrMode[180] = .SF;
        decodeMnemonic[181] = .CPBA; decodeAddrMode[181] = .X;
        decodeMnemonic[182] = .CPBA; decodeAddrMode[182] = .SX;
        decodeMnemonic[183] = .CPBA; decodeAddrMode[183] = .SFX;
        
        decodeMnemonic[184] = .CPBX; decodeAddrMode[184] = .I;
        decodeMnemonic[185] = .CPBX; decodeAddrMode[185] = .D;
        decodeMnemonic[186] = .CPBX; decodeAddrMode[186] = .N;
        decodeMnemonic[187] = .CPBX; decodeAddrMode[187] = .S;
        decodeMnemonic[188] = .CPBX; decodeAddrMode[188] = .SF;
        decodeMnemonic[189] = .CPBX; decodeAddrMode[189] = .X;
        decodeMnemonic[190] = .CPBX; decodeAddrMode[190] = .SX;
        decodeMnemonic[191] = .CPBX; decodeAddrMode[191] = .SFX;
        
        decodeMnemonic[192] = .LDWA; decodeAddrMode[192] = .I;
        decodeMnemonic[193] = .LDWA; decodeAddrMode[193] = .D;
        decodeMnemonic[194] = .LDWA; decodeAddrMode[194] = .N;
        decodeMnemonic[195] = .LDWA; decodeAddrMode[195] = .S;
        decodeMnemonic[196] = .LDWA; decodeAddrMode[196] = .SF;
        decodeMnemonic[197] = .LDWA; decodeAddrMode[197] = .X;
        decodeMnemonic[198] = .LDWA; decodeAddrMode[198] = .SX;
        decodeMnemonic[199] = .LDWA; decodeAddrMode[199] = .SFX;
        
        decodeMnemonic[200] = .LDWX; decodeAddrMode[200] = .I;
        decodeMnemonic[201] = .LDWX; decodeAddrMode[201] = .D;
        decodeMnemonic[202] = .LDWX; decodeAddrMode[202] = .N;
        decodeMnemonic[203] = .LDWX; decodeAddrMode[203] = .S;
        decodeMnemonic[204] = .LDWX; decodeAddrMode[204] = .SF;
        decodeMnemonic[205] = .LDWX; decodeAddrMode[205] = .X;
        decodeMnemonic[206] = .LDWX; decodeAddrMode[206] = .SX;
        decodeMnemonic[207] = .LDWX; decodeAddrMode[207] = .SFX;
        
        decodeMnemonic[208] = .LDBA; decodeAddrMode[208] = .I;
        decodeMnemonic[209] = .LDBA; decodeAddrMode[209] = .D;
        decodeMnemonic[210] = .LDBA; decodeAddrMode[210] = .N;
        decodeMnemonic[211] = .LDBA; decodeAddrMode[211] = .S;
        decodeMnemonic[212] = .LDBA; decodeAddrMode[212] = .SF;
        decodeMnemonic[213] = .LDBA; decodeAddrMode[213] = .X;
        decodeMnemonic[214] = .LDBA; decodeAddrMode[214] = .SX;
        decodeMnemonic[215] = .LDBA; decodeAddrMode[215] = .SFX;
        
        decodeMnemonic[216] = .LDBX; decodeAddrMode[216] = .I;
        decodeMnemonic[217] = .LDBX; decodeAddrMode[217] = .D;
        decodeMnemonic[218] = .LDBX; decodeAddrMode[218] = .N;
        decodeMnemonic[219] = .LDBX; decodeAddrMode[219] = .S;
        decodeMnemonic[220] = .LDBX; decodeAddrMode[220] = .SF;
        decodeMnemonic[221] = .LDBX; decodeAddrMode[221] = .X;
        decodeMnemonic[222] = .LDBX; decodeAddrMode[222] = .SX;
        decodeMnemonic[223] = .LDBX; decodeAddrMode[223] = .SFX;
        
        decodeMnemonic[224] = .STWA; decodeAddrMode[224] = .I;
        decodeMnemonic[225] = .STWA; decodeAddrMode[225] = .D;
        decodeMnemonic[226] = .STWA; decodeAddrMode[226] = .N;
        decodeMnemonic[227] = .STWA; decodeAddrMode[227] = .S;
        decodeMnemonic[228] = .STWA; decodeAddrMode[228] = .SF;
        decodeMnemonic[229] = .STWA; decodeAddrMode[229] = .X;
        decodeMnemonic[230] = .STWA; decodeAddrMode[230] = .SX;
        decodeMnemonic[231] = .STWA; decodeAddrMode[231] = .SFX;
        
        decodeMnemonic[232] = .STWX; decodeAddrMode[232] = .I;
        decodeMnemonic[233] = .STWX; decodeAddrMode[233] = .D;
        decodeMnemonic[234] = .STWX; decodeAddrMode[234] = .N;
        decodeMnemonic[235] = .STWX; decodeAddrMode[235] = .S;
        decodeMnemonic[236] = .STWX; decodeAddrMode[236] = .SF;
        decodeMnemonic[237] = .STWX; decodeAddrMode[237] = .X;
        decodeMnemonic[238] = .STWX; decodeAddrMode[238] = .SX;
        decodeMnemonic[239] = .STWX; decodeAddrMode[239] = .SFX;
        
        decodeMnemonic[240] = .STBA; decodeAddrMode[240] = .I;
        decodeMnemonic[241] = .STBA; decodeAddrMode[241] = .D;
        decodeMnemonic[242] = .STBA; decodeAddrMode[242] = .N;
        decodeMnemonic[243] = .STBA; decodeAddrMode[243] = .S;
        decodeMnemonic[244] = .STBA; decodeAddrMode[244] = .SF;
        decodeMnemonic[245] = .STBA; decodeAddrMode[245] = .X;
        decodeMnemonic[246] = .STBA; decodeAddrMode[246] = .SX;
        decodeMnemonic[247] = .STBA; decodeAddrMode[247] = .SFX;
        
        decodeMnemonic[248] = .STBX; decodeAddrMode[248] = .I;
        decodeMnemonic[249] = .STBX; decodeAddrMode[249] = .D;
        decodeMnemonic[250] = .STBX; decodeAddrMode[250] = .N;
        decodeMnemonic[251] = .STBX; decodeAddrMode[251] = .S;
        decodeMnemonic[252] = .STBX; decodeAddrMode[252] = .SF;
        decodeMnemonic[253] = .STBX; decodeAddrMode[253] = .X;
        decodeMnemonic[254] = .STBX; decodeAddrMode[254] = .SX;
        decodeMnemonic[255] = .STBX; decodeAddrMode[255] = .SFX;
    }

    
    func getInstruction(_ someInt: Int) -> String {
        if someInt > 255 || someInt < 0 {
            return "ERROR"
        }
        return "\(enumToMnemonMap[decodeMnemonic[someInt]]!)\(commaSpaceStringForAddrMode(addressMode: decodeAddrMode[someInt]))"
    }
    
}
