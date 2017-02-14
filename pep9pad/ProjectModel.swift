//
//  ProjectModel.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

/// Global, used to access the currently-edited project and interact with the fs.
var projectModel = ProjectModel()

class ProjectModel {
    
    
    // MARK: - Attributes
    
    /// The state of this project in the filesystem.  Defaults to .SavedNamed on launch.
    /// See pep9pad/Documentation for a state diagram of the filesystem.
    var fsState: FSState = .SavedNamed
    
    
    /// Note: this class treats the source, object, and listing as plain Strings.

    /// The name of the current project.  Default is empty string.
    var name: String = ""
    /// The assembly source of the current project.  Default is empty string.
    var sourceStr: String = ""
    /// The object code of the current project. Default is empty string.
    var objectStr: String = ""
    /// The assembler listing of the current project. Default is empty string.
    var listingStr: String = ""
    
//    // I think these belog in trace model.
//    var listingTrace: [String] = []
//    var hasCheckBox: [Bool] = []
    
    
    
    // MARK: - Methods
    
    /// Clears all data from `projectModel` and sets its state to `.Blank`.
    /// Does not create a new project in the filesystem.
    func newBlankProject() {
        fsState = .Blank
        name = ""
        sourceStr = ""
        objectStr = ""
        listingStr = ""
    }

    /// Loads an existing project's `name`, `source`, `object`, and `listing`
    /// from the filesystem (coredata database).
    /// Returns `false` if no project is found with the given name.
    func loadExistingProject(named n: String) -> Bool {
        if let file: P9Project = p9FileSystem.loadProject(named: n) {
            fsState = .SavedNamed
            name = file.name
            sourceStr = file.source
            objectStr = file.object
            listingStr = file.listing
            return true
        }
        return false
    }
    
    /// Loads the default project, aka `myFirstProgram`, directly from source files.
    /// In other words, **this function does not use CoreData.**
    func loadDefaultProject() {
        // don't bother loading from coredata
        // just load that hello world program
        let pathToSource = Bundle.main.path(forResource: "myFirstProject", ofType: "pep")
        let pathToObject = Bundle.main.path(forResource: "myFirstProject", ofType: "pepo")
        let pathToListing = Bundle.main.path(forResource: "myFirstProject", ofType: "pepl")

        do {
            print("Loaded default project.")
            name = "My First Project"
            sourceStr = try String(contentsOfFile:pathToSource!, encoding: String.Encoding.ascii)
            objectStr = try String(contentsOfFile:pathToObject!, encoding: String.Encoding.ascii)
            listingStr = try String(contentsOfFile:pathToListing!, encoding: String.Encoding.ascii)

        } catch _ as NSError {
            print("Could not load default project.")
            return
        }

    }
    
    func loadExample(text: String, ofType: PepFileType) {
        // TODO: Figure out whether the user has unsaved work and ask accordingly
        switch ofType {
        case .pep:
            sourceStr = text
            objectStr = ""
            listingStr = ""
            fsState = .UnsavedUnnamed
        case .pepo, .peph:
            sourceStr = ""
            objectStr = text
            listingStr = ""
            fsState = .UnsavedUnnamed
            
        default:
            break
        }

    }
    
    
    func saveProject() {
        if p9FileSystem.updateProject(named: name, source: sourceStr, object: objectStr, listing: listingStr) {
            fsState = .SavedNamed
        }
    }
    
    func saveAsNewProject(withName: String) {
        name = withName
        if p9FileSystem.saveNewProject(named: name, source: sourceStr, object: objectStr, listing: listingStr) {
            fsState = .SavedNamed
        }
    }
    
    
    func getData(ofType: ProjectContents) -> Data! {
        switch ofType {
        case .source:
            return sourceStr.data(using: .utf8)
        case .object:
            return objectStr.data(using: .utf8)
        case .listing:
            return listingStr.data(using: .utf8)
        default:
            break
        }
    }
    
    /// Called by classes that conform to `ProjectModelEditor` (i.e. the source, object, and listing vcs)
    /// whenever an editor detects the user has edited its `textField`'s contents.
    /// This function sets `fsState` accordingly.
    func receiveChanges(from editor: ProjectModelEditor, text: String) {
        if editor is SourceController {
            sourceStr = text
            changeStateToUnsaved()
        } else if editor is ObjectController {
            objectStr = text
            changeStateToUnsaved()
        } else if editor is ListingController {
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
