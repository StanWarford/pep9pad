//
//  ObjectTextModel.swift
//  pep9pad
//
//  Created by Stan Warford on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

class ObjectTextModel {
    
    var text: String = ""
    
    func clear() {
        text = ""
    }
    
}


/// This global variable is initialized on launch.
/// Its `text` attribute is initialized to the empty string.
var objectTextModel = ObjectTextModel()
