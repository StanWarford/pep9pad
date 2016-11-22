//
//  ASMSourceCodeViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/12/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class ASM_SourceViewController: UIViewController, ASM_ProjectModelEditor, PepTextViewDelegate {
    
    
    // MARK: - Properties
    var sourceCode: [Code] = []
    var objectCode: [Int] = []
    var assemblerListing: [String] = []
    var listingTrace: [String] = []
    var hasCheckBox: [Bool] = []
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setupTextView(textView.frame, delegate: self)
        pullFromProjectModel()
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
    
    // Pre: self.sourceCode is populated with code from a complete correct Pep/9 source program.
    // Post: self.objectCode is populated with the object code, one byte per entry, and returned.
    func getObjectCode() -> [Int] {
        // PLACEHOLDER
        return [0]
    }
    
    // Pre: self.sourceCode is populated with code from a complete correct Pep/9 source program.
    // Post: self.assemblerListing is populated with the assembler listing.
    // Post: self.listingTrace is populated with the object code.
    // Post: self.hasCheckBox is populated with the checkBox list that specifies whether a trace line can have a break point.
    // Post: assemblerListing is returned.
    func getAssemblerListing() -> [String] {
        // PLACEHOLDER
        return [""]
    }
    
    // Pre: self.listingTrace is populated.
    // Post: self.listingTrace is returned.
    func getListingTrace() -> [String] {
        // PLACEHOLDER
        return [""]
    }
    
    // Pre: self.hasCheckBox is populated.
    // Post: self.hasCheckBox is returned.
    func getHasCheckBox() -> [Bool] {
        // PLACEHOLDER
        return [true]
    }
    
    // Pre: self.sourceCode is populated with code from a complete correct Pep/9 source program.
    // Post: The memAddress field of each code object is incremented by addressDelta.
    func adjustSourceCode(addressDelta: Int) {
        
    }
    
    // Pre: self.objectCode is populated with code from a complete correct Pep/9 OS source program.
    // Post: self.objectCode is loaded into OS rom of pep.mem
    func installOS() {
        
    }
    
    // Post: the pep/9 operating system is installed into memory, and true is returned
    // If assembly fails, false is returned
    // This function should only be called on program startup once
    func installDefaultOS() -> Bool {
        // PLACEHOLDER
        return true
    }
    
    // Post: Searces for the string ";ERROR: " on each line and removes the end of the line.
    // Post: Searces for the string ";WARNING: " on each line and removes the end of the line.
    func removeErrorMessages() {
        
    }
    
    // Post: Appends message to the end of line lineNumber in a reserved color.
    func appendMessageInSourceCodeAt(lineNumber: Int, message: String) {
        
    }
    
    // Post: Sets text in source code pane to `toString`.
    func setSourceCode(toString: String) {
        
    }
    
    // Post: Clears the textView.
    func clear() {
        
    }
    
    
    // MARK: - Conformance to ASM_ProjectModelEditor
    
    /// Updates the contents of the `textView` with `projectModel.source`.
    func pullFromProjectModel() {
        textView.setText(projectModel.source)
    }
    
    /// Updates `projectModel.source` with the contents of `textView`.
    func pushToProjectModel() {
        projectModel.receiveChanges(pushedFrom: self, text: textView.getText())
    }
    
    
    // MARK: - Conformance to PepTextViewDelegate
    func textViewDidChange() {
        pushToProjectModel()
    }
    
    

    
}
