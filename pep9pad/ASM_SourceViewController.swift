//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/12/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_SourceViewController: UIViewController, ASM_EditorProtocol {
    
    
    
    // MARK: - Properties
    var sourceCode: [Code] = []
    var objectCode: [Int] = []
    var assemblerListing: [String] = []
    var listingTrace: [String] = []
    var hasCheckBox: [Bool] = []
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame)
        updateFromModel()
    }
    
    
    
    // MARK: - Interface Builder
    
    /// The primary view in this UIViewController.
    @IBOutlet var textView: PepTextView!
    
    
    
    // MARK: - Methods
    
    // Pre: self.textView.text contains a Pep/9 source program.
    // Post: If the program assembles correctly, true is returned, and sourceCode is populated
    // with the code objects. Otherwise false is returned and codeList is partially populated.
    // Post: pep.symbolTable is populated with values not adjusted for .BURN.
    // Post: pep.byteCount is the byte count for the object code not adjusted for .BURN.
    // Post: pep.burnCount is the number of .BURN instructions encountered in the source program.
    func assemble() -> Bool {
        // PLACEHOLDER
        return true
    }
    
    /// Updates the contents of the `textView` with `editorModel.source`.
    func updateFromModel() {
        textView.setText(editorModel.source)
    }
    
    // Pre: self.sourceCode is populated with code from a complete correct Pep/9 source program.
    // Post: self.objectCode is populated with the object code, one byte per entry, and returned.
    func getObjectCode() -> [Int] {
        // PLACEHOLDER
        return [0]
    }
    
    // Pre: self.sourceCode is populated with code from a complete correct Pep/9 source program.
    // Post: self.assemlberListing is populated with the assembler listing.
    // Post: self.listingTrace is populated with the object code.
    // Post: self.hasCheckBox is populated with the checkBox list that specifies whether a trace line can have a break point.
    // Post: assemblerListingList is returned.
    func getAssemblerListing() -> [String] {
        
    }

    
    
    
    

    
}
