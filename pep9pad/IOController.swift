//
//  ASM-IOViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 10/11/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit



/// Represents the two possible modes of an `ASMIOView` object.
/// * The `batch` mode corresponds to two text input panels, an input and output
/// * The `terminal` mode corresponds to a single text input/output panel
enum IOViewMode {
    case batch
    case terminal
}




/// A `UIViewController` which handles batch and terminal input / output.
class IOController: UIViewController, UITextViewDelegate {
    
    
    
    /// Represents the current mode of this view. Default value is `.batch`
    /// * The `batch` mode corresponds to two text input panels, an input and output
    /// * The `terminal` mode corresponds to a single text input/output panel
    var currentMode: IOViewMode = .batch
    
    /// The duration (in seconds) of the animated transition between io modes.
    var animationDuration: Double = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    /// Changes the view to represent `requestedMode` and adjusts `currentMode` to match.
    /// Does nothing if `requestedMode == currentMode`.
    func setIOMode(to requestedMode: IOViewMode) {
        if currentMode == requestedMode {
            // caller is requesting a change that is not needed.
            return
        } else {
            // we must change the mode
            switch requestedMode {
            case .batch:
                // switch to batch mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setIOMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForBatch
                currentMode = .batch
                
                // grow bottomTextView to take up half of view, and shrink topTextView to take up other half
                let viewHeight = view.frame.height
                let viewWidth = view.frame.width
                let heightOfEach = (viewHeight-44)/2
                let newRectForTop = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: viewWidth, height: heightOfEach)
                let newRectForBottom = CGRect(x: view.frame.origin.x, y: viewHeight/2+22, width: viewWidth, height: heightOfEach)
                UIView.animate(withDuration: 0.25) {
                    self.topTextView.frame = newRectForTop
                    self.bottomTextView.frame = newRectForBottom
                }

                
            case .terminal:
                // switch to terminal mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setIOMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForTerminal
                currentMode = .terminal
                
                // grow topTextView to take up entire view, and shrink bottomTextView to height of 0
                let viewHeight = view.frame.height
                let viewWidth = view.frame.width
                let newRectForTop = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: viewWidth, height: viewHeight-44)
                let newRectForBottom = CGRect(x: view.frame.origin.x, y: viewHeight, width: viewWidth, height: 0)
                UIView.animate(withDuration: 0.25) {
                    self.topTextView.frame = newRectForTop
                    self.bottomTextView.frame = newRectForBottom
                }
            }
        }
    }
    
    
    
    
    // MARK: - Interface Builder
    
    @IBOutlet var topTextView: UITextView!
    @IBOutlet var bottomTextView: UITextView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    /// Segmented control index for the 'Batch' option.
    var segIdxForBatch = 0
    /// Segmented control index for the 'Terminal' option.
    var segIdxForTerminal = 1
    
    /// An action that is triggered whenever the value of the `segmentedControl` object is changed.
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case segIdxForTerminal:
            setIOMode(to: .terminal)
        default:
            setIOMode(to: .batch)
            
        }
    }
    
    
}
