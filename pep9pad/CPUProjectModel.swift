//
//  CPUProjectModel.swift
//  pep9pad
//
//  Created by Josh Haug on 1/30/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

/// Global, used to access the currently-edited project and interact with the fs.
var cpuProjectModel = CPUProjectModel()

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
    /// The size of the bus.
    var busSize: CPUBusSize = .oneByte
    
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
        if let file: CPUProject = cpuFileSystem.loadProject(named: n) {
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
        let pathToSource = Bundle.main.path(forResource: "myFirstCPUProject", ofType: "pepcpu")
        
        do {
            print("Loaded file named myFirstCPUProject.pepcpu")
            name = "My First CPU Project"
            sourceStr = try String(contentsOfFile:pathToSource!, encoding: String.Encoding.ascii)
        } catch _ as NSError {
            print("Could not load file named myFirstCPUProject.pepcpu")
            return
        }
        
    }
    
    func loadExample(text: String, ofType: PepFileType) {
        // TODO: Figure out whether the user has unsaved work and ask accordingly
        switch ofType {
        case .pepcpu:
            sourceStr = text
            fsState = .UnsavedUnnamed
            
        default:
            break
        }
        
    }
    
    
    func saveExistingProject() {
        if cpuFileSystem.updateProject(named: name, source: sourceStr) {
            fsState = .SavedNamed
            addProjectNameToRecents(name)
        } else {
            // project could not be updated in FS
        }
    }
    
    func saveAsNewProject(withName: String) {
        name = withName
        if cpuFileSystem.saveNewProject(named: name, source: sourceStr) {
            fsState = .SavedNamed
            addProjectNameToRecents(name)
        }
    }
    
    
    // Called by classes that conform to `ProjectModelEditor` (i.e. the source, object, and listing vcs)
    // whenever an editor detects the user has edited its `textField`'s contents.
    // This function sets `fsState` accordingly.
    func receiveChanges(from editor: ProjectModelEditor, text: String) {
        if editor is CPUSplitController {
            sourceStr = text
            changeStateToUnsaved()
        } else {
            // unrecognized call
            assert(false)
        }
    }
    
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
    
    
    
    
    // MARK: Recent Projects Stuff
    
    /// The key used for UserDefaults for recent projects.
    let recentProjectsKey: String  = "Pep9PadCPURecentProjectsKeyForUserDefaults"
    /// The maximum number of recent project names to keep.
    let maxRecentProjects: Int = 5
    
    /// Returns an array of recent project names.
    func recentProjectNames() -> [String] {
        if UserDefaults.standard.stringArray(forKey: recentProjectsKey) == nil {
            // has never been set before, which means this user has never saved a project before
            UserDefaults.standard.set(["My First CPU Project"], forKey: recentProjectsKey)
            UserDefaults.standard.synchronize()
        }
        
        return UserDefaults.standard.stringArray(forKey: recentProjectsKey)!
    }
    
    /// Places the given name into the array of recent project names.
    /// Done through UserDefaults.
    func addProjectNameToRecents(_ nameOfProject: String) {
        if UserDefaults.standard.stringArray(forKey: recentProjectsKey) == nil {
            // should not happen but including this for posterity
            // has never been set before, which means this user has never saved a project before
            UserDefaults.standard.set(["My First CPU Project"], forKey: recentProjectsKey)
            UserDefaults.standard.synchronize()
        }
        
        var names = UserDefaults.standard.stringArray(forKey: recentProjectsKey)!
        
        // check if already in list, so we don't have the same entry twice
        if names.contains(nameOfProject) {
            // this project is already in the list
            // just move it to the front if it isn't already there
            let curIdx = names.index(of: nameOfProject)!
            names.remove(at: curIdx)
        }
        
        // insert it at the front
        names.insert(nameOfProject, at: 0)
        
        
        // ensure that we're not saving too many
        if names.count >= maxRecentProjects {
            // got too big, need to remove the last one
            names.removeLast()
        }
        
        // now save
        UserDefaults.standard.set(names, forKey: recentProjectsKey)
        UserDefaults.standard.synchronize()
    }
    
    
    func getData() -> Data! {
        return sourceStr.data(using: .utf8)
    }
    
    
}
