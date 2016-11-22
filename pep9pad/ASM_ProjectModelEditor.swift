//
//  ASM_ProjectModelEditor.swift
//  pep9pad
//
//  Created by Josh Haug on 11/3/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

protocol ASM_ProjectModelEditor {
    func updateFromProjectModel()
    var textView: PepTextView! {
        get set
    }
}
