//
//  ASM-IOView.swift
//  pep9pad
//
//  Created by Josh Haug on 10/11/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit



/// Represents the two possible modes of an `ASMIOView` object.
/// * The `batch` mode corresponds to two text input panels, an input and output
/// * The `terminal` mode corresponds to a single text input/output panel
enum ASMIOViewMode {
    case batch
    case terminal
}




/// A `UIView` which handles batch and terminal input / output.
class ASMIOView: UIView, UITextViewDelegate {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /// Represents the current mode of this view. Default value is `.batch`
    /// * The `batch` mode corresponds to two text input panels, an input and output
    /// * The `terminal` mode corresponds to a single text input/output panel
    var currentMode: ASMIOViewMode = .batch
    
    
    
    /// Changes the view to represent `requestedMode` and adjusts `currentMode` to match.
    /// Does nothing if `requestedMode == currentMode`.
    func setIOMode(to requestedMode: ASMIOViewMode) {
        if currentMode == requestedMode {
            // caller is requesting a change that is not needed.
            return
        } else {
            // we must change the mode
            switch requestedMode {
            case .batch:
                // TODO: handle this change
                currentMode = .batch
            case .terminal:
                // TODO: handle this change
                currentMode = .terminal
            }
        }
    }
    
    
}
