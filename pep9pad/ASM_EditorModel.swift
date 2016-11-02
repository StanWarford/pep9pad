//
//  ASM_EditorModel.swift
//  pep9pad
//
//  Created by Josh Haug on 11/2/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// Singleton instance, used to express the currently-edited project.
var editorModel = EditorModel()

class EditorModel {
    
    var name: String! = nil
    var type: PepFileType = .pep
    var source: String = ""
    
    func newFile() {
        name = ""
        type = .pep
        source = ""
    }

    
    func loadExistingFile(named n: String) -> Bool {
        if let file: FSEntity = loadFileFromFS(named: n) {
            self.name = file.name
            self.type = PepFileType(rawValue: file.type)!
            self.source = file.source
            return true
        }
        return false
    }
    
    
    
    
}
