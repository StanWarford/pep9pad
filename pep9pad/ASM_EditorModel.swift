//
//  ASM_EditorModel.swift
//  pep9pad
//
//  Created by Josh Haug on 11/2/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

/// Global, used to access the currently-edited project.
var editorModel = EditorModel()

class EditorModel {
    
    var name: String! = nil
    var source: String = ""
    var object: String = ""
    var listing: String = ""
    
    func newProject() {
        name = ""
        source = ""
        object = ""
        listing = ""
    }

    
    func loadExistingProject(named n: String) -> Bool {
        if let file: FSEntity = loadFileFromFS(named: n) {
            name = file.name
            source = file.source
            object = file.object
            listing = file.listing
            return true
        }
        return false
    }
    
    
    func loadDefaultProject() {
        // don't bother loading from coredata
        // just load that hello world program
        guard let path = Bundle.main.path(forResource: "myFirstProgram", ofType: "pep") else {
            print("Could not load file named myFirstProgram.pep")
            return
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.ascii)
            print("Loaded file named myFirstProgram.pep")
            name = "My First Program"
            source = content
        } catch _ as NSError {
            print("Could not load file named myFirstProgram.pep")
            return
        }

    }
    
    
    
    
}
