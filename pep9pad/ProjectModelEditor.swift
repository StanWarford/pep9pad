//
//  ProjectModelEditor.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

protocol ProjectModelEditor {
    /// Pull any changes from the global `projectModel` into this editor's `textView`.
    func pullFromProjectModel()
    /// Push any changes from this editor's `textView` into the global `projectModel`.
    func pushToProjectModel()
    var textView: PepTextView! {
        get set
    }
}
