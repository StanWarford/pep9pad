//
//  CPUProjectModel.swift
//  pep9pad
//
//  Created by Josh Haug on 1/30/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

/// Global, used to access the currently-edited project and interact with the fs.
var cpuProjectModel = ProjectModel()

class CPUProjectModel {
    
    
    // MARK: - Attributes
    
    /// The state of this project in the filesystem.  Defaults to .SavedNamed on launch.
    /// See pep9pad/Documentation for a state diagram of the filesystem.
    var fsState: FSState = .SavedNamed
    
    
    /// Note: this class treats the source as a plain String.
    
    /// The name of the current project.  Default is empty string.
    var name: String = ""
    /// The assembly source of the current project.  Default is empty string.
    var sourceStr: String = ""

    
    // MARK: - Methods
    
    /// Clears all data from `projectModel` and sets its state to `.Blank`.
    /// Does not create a new project in the filesystem.
    func newBlankProject() {
        fsState = .Blank
        name = ""
        sourceStr = ""
    }
    
    /// Loads an existing project's `name`, `source`, `object`, and `listing`
    /// from the filesystem (coredata database).
    /// Returns `false` if no project is found with the given name.
    func loadExistingProject(named n: String) -> Bool {
        if let file: P9Project = p9FileSystem.loadProject(named: n) {
            fsState = .SavedNamed
            name = file.name
            sourceStr = file.source
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
        
        do {
            print("Loaded file named myFirstProgram.pep")
            name = "My First Program"
            sourceStr = try String(contentsOfFile:pathToSource!, encoding: String.Encoding.ascii)
        } catch _ as NSError {
            print("Could not load file named myFirstProgram.pep")
            return
        }
        
    }
    
    func loadExample(text: String, ofType: PepFileType) {
        // TODO: Figure out whether the user has unsaved work and ask accordingly
        switch ofType {
        case .pep:
            sourceStr = text
            fsState = .UnsavedUnnamed
        case .pepo, .peph:
            sourceStr = ""
            fsState = .UnsavedUnnamed
            
        default:
            break
        }
        
    }
    
    
//    func saveProjectInFS() {
//        if updateProjectInFS(named: name, source: sourceStr) {
//            fsState = .SavedNamed
//        }
//    }
//    
//    func saveAsNewProjectInFS(withName: String) {
//        name = withName
//        if saveNewProjectInFS(named: name, source: sourceStr) {
//            fsState = .SavedNamed
//        }
//    }
    
    
    /// Called by classes that conform to `ProjectModelEditor` (i.e. the source, object, and listing vcs)
    /// whenever an editor detects the user has edited its `textField`'s contents.
    /// This function sets `fsState` accordingly.
//    func receiveChanges(from editor: ProjectModelEditor, text: String) {
//        if editor is CPUSourceController {
//            sourceStr = text
//            changeStateToUnsaved()
//        } else {
//            // unrecognized call
//            assert(false)
//        }
//    }
    
    /// Called by `self.receiveChanges()` whenever a change has been detected in source code.
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
