//
//  ProjectModelEditor.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// Defines communication between viewcontrollers and the projectmodel. Implemented by the source, object, and listing controllers.
protocol ProjectModelEditor {
    /// Pull any changes from the global `projectModel` into this editor's `textView`.
    func pullFromProjectModel()
    /// Push any changes from this editor's `textView` into the global `projectModel`.
    func pushToProjectModel()
    /// The text view (owned by the viewcontroller).
    var textView: CodeView! { get set }
}
