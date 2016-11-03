//
//  ASM_EditorModel.swift
//  pep9pad
//
//  Created by Josh Haug on 11/2/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

/// Global, used to access the currently-edited project.
var editorModel = ASM_EditorModel()

class ASM_EditorModel {
    
    
    // MARK: - Attributes
    /// The state of this project in the filesystem.  Defaults to .SavedNamed on launch.
    var fsState: FSState = .SavedNamed
    /// The name of the current project.  Default is empty string.
    var name: String = ""
    /// The assembly source of the current project.  Default is empty string.
    var source: String = ""
    /// The object code of the current project. Default is empty string.
    var object: String = ""
    /// The assembler listing of the current project. Default is empty string.
    var listing: String = ""
    
    
    // MARK: - Methods
    
    /// Creates a blank project in the global `editorModel`.
    /// **Changes the
    /// Does not create a new project in the filesystem.
    func newProject() {
        fsState = .Blank
        name = ""
        source = ""
        object = ""
        listing = ""
    }

    /// Loads an existing project's `name`, `source`, `object`, and `listing`
    /// from the filesystem (coredata database).
    /// Returns `false` if no project is found with the given name.
    func loadExistingProject(named n: String) -> Bool {
        if let file: FSEntity = loadProjectFromFS(named: n) {
            fsState = .SavedNamed
            name = file.name
            source = file.source
            object = file.object
            listing = file.listing
            return true
        }
        return false
    }
    
    /// Loads the default project, aka `myFirstProgram`, directly from source files.
    /// In other words, **this function does not use coredata.**
    /// Called by 
    func loadDefaultProject() {
        // don't bother loading from coredata
        // just load that hello world program
        let pathToSource = Bundle.main.path(forResource: "myFirstProgram", ofType: "pep")
        let pathToObject = Bundle.main.path(forResource: "myFirstProgram", ofType: "pepo")
        let pathToListing = Bundle.main.path(forResource: "myFirstProgram", ofType: "pepl")

        do {
            print("Loaded file named myFirstProgram.pep")
            name = "My First Program"
            source = try String(contentsOfFile:pathToSource!, encoding: String.Encoding.ascii)
            object = try String(contentsOfFile:pathToObject!, encoding: String.Encoding.ascii)
            listing = try String(contentsOfFile:pathToListing!, encoding: String.Encoding.ascii)

        } catch _ as NSError {
            print("Could not load file named myFirstProgram.pep")
            return
        }

    }
    
    func loadExample(text: String, ofType: PepFileType) {
        // TODO: Figure out whether the user has unsaved work and ask accordingly
        switch ofType {
        case .pep:
            source = text
            object = ""
            listing = ""
            
        case .pepo, .peph:
            source = ""
            object = text
            listing = ""
            
        default:
            break
        }

    }
    
    
    
    
}
