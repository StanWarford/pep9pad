//
//  ASM_ProjectModel.swift
//  pep9pad
//
//  Created by Josh Haug on 11/2/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

/// Global, used to access the currently-edited project and interact with the fs.
var projectModel = ASM_ProjectModel()

class ASM_ProjectModel {
    
    
    // MARK: - Attributes
    
    /// The state of this project in the filesystem.  Defaults to .SavedNamed on launch.
    /// See Docs/
    var fsState: FSState = .SavedNamed
    
    /// The name of the current project.  Default is empty string.
    var name: String = ""
    /// The assembly source of the current project.  Default is empty string.
    var source: String = ""
    /// The object code of the current project. Default is empty string.
    var object: String = ""
    /// The assembler listing of the current project. Default is empty string.
    var listing: String = ""
    
    /// Parsed source code, an array of Code objects.
    var sourceCode: [Code] = []
    /// Parsed object code, an array of integers corresponding to
    var objectCode: [Int] = []
    /// The listing generated from the most recent assembler call.
    var assemblerListing: [String] = []
    
    // I think these belog in trace model.
    var listingTrace: [String] = []
    var hasCheckBox: [Bool] = []
    
    
    
    // MARK: - Methods
    
    /// Clears all data from `projectModel` and sets its state to `.Blank`.
    /// Does not create a new project in the filesystem.
    func newBlankProject() {
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
    /// In other words, **this function does not use CoreData.**
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
    
    
    func saveProjectInFS() {
        if updateProjectInFS(named: name, source: source, object: object, listing: listing) {
            fsState = .SavedNamed
        }
    }
    
    func saveProjectAsNewProjectInFS(withName: String) {
        if saveNewProjectInFS(named: name, source: source, object: object, listing: listing) {
            fsState = .SavedNamed
        }
    }
    
    
    /// Called by classes that conform to `ASM_ProjectModelEditor` (i.e. the source, object, and listing vcs)
    /// whenever an editor detects the user has edited its `textField`'s contents.
    /// This function sets `fsState` accordingly.
    func receiveChanges(pushedFrom editor: ASM_ProjectModelEditor, text: String) {
        if editor is ASM_SourceViewController {
            source = text
            changeStateToUnsaved()
        } else if editor is ASM_ObjectViewController {
            object = text
            changeStateToUnsaved()
        } else if editor is ASM_ListingViewController {
            // I can't think of a reason why this would ever be called.
            assert(false)
        } else {
            // unrecognized call
            assert(false)
        }
    }
    
    /// Called by `self.receiveChanges()` whenever a change has been detected in source or object code. 
    /// Marks the current project as .UnsavedNamed or .UnsavedUnnamed, depending on the current value of `fsState`.
    func changeStateToUnsaved() {
        switch fsState {
        case .SavedNamed:
            fsState = .UnsavedNamed
        case .Blank:
            fsState = .UnsavedUnnamed
        case .UnsavedNamed, .UnsavedUnnamed:
            // no change needed
            break
        }
    }
    
    
    
    
    
    
    
}
