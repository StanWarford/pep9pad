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
    
    
    // MARK: Recent Projects Stuff
    
    /// The key used for UserDefaults for recent projects.
    let recentProjectsKey: String  = "Pep9PadRecentProjectsKeyForUserDefaults"
    /// The maximum number of recent project names to keep.
    let maxRecentProjects: Int = 5
    
    /// Returns an array of recent project names.
    func recentProjectNames() -> [String] {
        if UserDefaults.standard.stringArray(forKey: recentProjectsKey) == nil {
            // has never been set before, which means this user has never saved a project before
            UserDefaults.standard.set(["My First Project"], forKey: recentProjectsKey)
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
            UserDefaults.standard.set(["My First Project"], forKey: recentProjectsKey)
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
    
    
    
    func loadExample(text: String, ofType: PepFileType) {
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
    
    
    func saveExistingProject() {
        if p9FileSystem.updateProject(named: name, source: sourceStr, object: objectStr, listing: listingStr) {
            fsState = .SavedNamed
            addProjectNameToRecents(name)
        } else {
            // project could not be updated in FS
        }
    }
    
    func saveAsNewProject(withName: String) {
        name = withName
        if p9FileSystem.saveNewProject(named: name, source: sourceStr, object: objectStr, listing: listingStr) {
            fsState = .SavedNamed
            addProjectNameToRecents(name)
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
    
    
    // Post: Searces for the string ";ERROR: " on each line and removes the end of the line.
    // Post: Searces for the string ";WARNING: " on each line and removes the end of the line.
    func removeErrorMessages() {
        let text : String = sourceStr
        var textArr = text.components(separatedBy: "\n")
        for var i in textArr {
            if (i.contains(";ERROR") || i.contains(";WARNING")) {
                for charIdx in i.characters.count...0 {
                    i.char
                }
            }
        }
        sourceStr = textArr.joined(separator: "\n")

    }
    
    
    
    
    
    func appendMessageInSource(atLine: Int, message: String) {
        // make an array of all lines in sourceString
        var lineArray: [String] = []
        sourceStr.enumerateLines { (line, stop) -> () in
            lineArray.append(line)
        }
        // now alter the line in question
        let lineIndex = atLine // atLine-1
        if lineIndex < lineArray.count {
            lineArray[lineIndex].append(message)
            sourceStr = lineArray.joined(separator: "\n")
        } else {
            print("Incorrect line number given for appendErrorInSource(::)")
        }
    }
    
    
    
}
