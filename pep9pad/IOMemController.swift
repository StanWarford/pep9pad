//
//  ASM-IOViewController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit



/// Represents the three possible modes of an `IOMemCoontroller` object.
/// * The `batchIO` mode corresponds to two text input panels, an input and output
/// * The `terminalIO` mode corresponds to a single text input/output panel
/// * The `memory` mode corresponds to a single main memory panel
enum IOMemMode {
    case batchIO
    case terminalIO
    case memory
}




/// A `UIViewController` which handles batch and terminal input / output.
class IOMemController: UIViewController, UITextViewDelegate {
    
    
    
    /// Represents the current mode of this view. Default value is `.batchIO`
    /// * The `batchIO` mode corresponds to two text input panels, an input and output
    /// * The `terminalIO` mode corresponds to a single text input/output panel
    /// * The `memory` mode corresponds to a single main memory panel
    var currentMode: IOMemMode = .batchIO
    
    /// The duration (in seconds) of the animated transition between io modes.
    var animationDuration: Double = 0.18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        batchInputTextView = UITextView()
        batchInputTextView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: view.frame.width, height: (view.frame.height-44)/3)
        batchInputTextView.font = UIFont(name: "Courier", size: 15)
        batchInputTextView.text = "Batch Input placeholder"
        view.addSubview(batchInputTextView)

        batchOutputTextView = UITextView()
        batchOutputTextView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+22+(view.frame.height/3), width: view.frame.width, height: (view.frame.height-44)/3)
        batchOutputTextView.font = UIFont(name: "Courier", size: 15)
        batchOutputTextView.text = "Batch Output placeholder"
        view.addSubview(batchOutputTextView)

        terminalTextView = UITextView()
        terminalTextView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: view.frame.width, height: view.frame.height-44)
        terminalTextView.isHidden = true
        terminalTextView.font = UIFont(name: "Courier", size: 15)
        terminalTextView.text = "Terminal I/O placeholder"
        view.addSubview(terminalTextView)

        
        
        memoryView = Bundle.main.loadNibNamed("MemoryHeader", owner: self, options: nil)![0] as! UIView as! MemoryView
        //self.addSubview(view)
        memoryView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: view.frame.width, height: view.frame.height-44)
        

        
        ///memoryView = //MemoryView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: view.frame.width, height: view.frame.height-44))
        
        //memoryView.frame =
        memoryView.isHidden = true
        view.addSubview(memoryView)
        

        view.clipsToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setInput(_ to: String) {
        switch (currentMode) {
        case .batchIO:
            batchInputTextView.text = to
        case .terminalIO:
            terminalTextView.text = to
        default:
            break
        }
    }
    
    func appendOutput(_ thing: String) {
        switch (currentMode) {
        case .batchIO:
            batchOutputTextView.text.append(thing)
            //batchOutputTextView.scrollToBottom()
        case .terminalIO:
            terminalTextView.text.append(thing)
            //terminalTextView.scrollToBottom()
        default:
            break
        }
    }
    
    /// Changes the view to represent `requestedMode` and adjusts `currentMode` to match.
    /// Does nothing if `requestedMode == currentMode`.
    func setMode(to requestedMode: IOMemMode) {
        if currentMode == requestedMode {
            // caller is requesting a change that is not needed.
            return
        } else {
            // we must change the mode
            switch requestedMode {
            case .batchIO:
                // switch to batch mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForBatchIO
                currentMode = .batchIO
                
//                // grow bottomTextView to take up half of view, and shrink topTextView to take up other half
//                let viewHeight = view.frame.height
//                let viewWidth = view.frame.width
//                let heightOfEach = (viewHeight-44)/2
//                let newRectForInput = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: viewWidth, height: heightOfEach)
//                let newRectForOutput = CGRect(x: view.frame.origin.x, y: viewHeight/2+22, width: viewWidth, height: heightOfEach)
//                let newRectForTerminal = CGRect(x: view.frame.origin.x, y: viewHeight, width: viewWidth, height: 0)
//                let newRectForMem = newRectForTerminal
                UIView.animate(withDuration: animationDuration) {
//                    self.batchInputTextView.frame = newRectForInput
//                    self.batchOutputTextView.frame = newRectForOutput
//                    self.terminalTextView.frame = newRectForTerminal
//                    self.memoryView.frame = newRectForMem
                    self.batchInputTextView.isHidden = false
                    self.batchOutputTextView.isHidden = false
                    self.terminalTextView.isHidden = true
                    self.memoryView.isHidden = true
                }

                
            case .terminalIO:
                // switch to terminal mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForTerminalIO
                currentMode = .terminalIO
                
//                // grow topTextView to take up entire view, and shrink bottomTextView to height of 0
//                let viewHeight = view.frame.height
//                let viewWidth = view.frame.width
//                let newRectForInput = CGRect(x: view.frame.origin.x, y: viewHeight, width: viewWidth, height: 0)
//                let newRectForOutput = newRectForInput
//                let newRectForTerminal = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: viewWidth, height: viewHeight-44)
//                let newRectForMem = newRectForInput
                UIView.animate(withDuration: animationDuration) {
//                    self.batchInputTextView.frame = newRectForInput
//                    self.batchOutputTextView.frame = newRectForOutput
//                    self.terminalTextView.frame = newRectForTerminal
//                    self.memoryView.frame = newRectForMem
                    self.batchInputTextView.isHidden = true
                    self.batchOutputTextView.isHidden = true
                    self.terminalTextView.isHidden = false
                    self.memoryView.isHidden = true
                }
            case .memory:
                // switch to memory mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForMemory
                currentMode = .memory
//                // grow topTextView to take up entire view, and shrink bottomTextView to height of 0
//                let viewHeight = view.frame.height
//                let viewWidth = view.frame.width
//                let newRectForInput = CGRect(x: view.frame.origin.x, y: viewHeight, width: viewWidth, height: 0)
//                let newRectForOutput = newRectForInput
//                let newRectForTerminal = newRectForInput
//                let newRectForMem = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+44, width: viewWidth, height: viewHeight-44)
                UIView.animate(withDuration: animationDuration) {
//                    self.batchInputTextView.frame = newRectForInput
//                    self.batchOutputTextView.frame = newRectForOutput
//                    self.terminalTextView.frame = newRectForTerminal
//                    self.memoryView.frame = newRectForMem
                    self.batchInputTextView.isHidden = true
                    self.batchOutputTextView.isHidden = true
                    self.terminalTextView.isHidden = true
                    self.memoryView.isHidden = false
                }
            }
        }
    }
    
    
    
    
    // MARK: - Interface Builder
    
    var batchInputTextView: UITextView!
    var batchOutputTextView: UITextView!
    var terminalTextView: UITextView!
    var memoryView: MemoryView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    /// Segmented control index for the 'Batch I/O' option.
    var segIdxForBatchIO = 0
    /// Segmented control index for the 'Terminal I/O' option.
    var segIdxForTerminalIO = 1
    /// Segmented contro index for the 'Memory" option.
    var segIdxForMemory = 2

    /// An action that is triggered whenever the value of the `segmentedControl` object is changed.
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case segIdxForTerminalIO:
            setMode(to: .terminalIO)
        case segIdxForBatchIO:
            setMode(to: .batchIO)
        case segIdxForMemory:
            setMode(to: .memory)
        default:
            assert(false)
            
        }
    }
    
    
}
