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

enum IOMode {
    case batch
    case terminal
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
    
    var simulatedIOMode: IOMode = .batch
    
    
    
    
    // MARK: - Interface Builder
    
    var memoryView: MemoryView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var inputTextView: UITextView!
    
    @IBOutlet var outputTextView: UITextView!
    
    @IBOutlet var terminalTextView: UITextView!
    
    
    @IBOutlet var inputLabel: UILabel!
    
    @IBOutlet var outputLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.font = UIFont(name: "Courier", size: 15)
        inputTextView.text = ""
        inputTextView.textContainer.lineBreakMode = .byWordWrapping

        print(view.bounds.width)
        
        outputTextView.font = UIFont(name: "Courier", size: 15)
        outputTextView.text = ""
        outputTextView.textContainer.lineBreakMode = .byWordWrapping

//        terminalTextView = inputTextView
        terminalTextView.isHidden = true
        terminalTextView.font = UIFont(name: "Courier", size: 15)
        terminalTextView.text = ""
        terminalTextView.textContainer.lineBreakMode = .byWordWrapping

        
        
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
            inputTextView.text = to
        case .terminalIO:
            terminalTextView.text = to
        default:
            break
        }
    }
    
    func appendOutput(_ thing: String) {
        switch (currentMode) {
        case .batchIO:
            outputTextView.text.append(thing)
            //outputTextView.scrollToBottom()
        case .terminalIO:
            terminalTextView.text.append(thing)
            //terminalTextView.scrollToBottom()
        default:
            break
        }
    }
    
    func startSimulation() {
        // disable the non-selected io mode
        // if mem is currently selected, default to batch
        switch (currentMode) {
        case .batchIO:
            segmentedControl.setEnabled(false, forSegmentAt: 1)
            simulatedIOMode = .batch
        case .terminalIO:
            segmentedControl.setEnabled(false, forSegmentAt: 0)
            simulatedIOMode = .terminal
        case .memory:
            setMode(to: .batchIO) // go to batch by default
            segmentedControl.setEnabled(false, forSegmentAt: 1)
            simulatedIOMode = .batch
        }
    }
    
    func stopSimulation() {
        // enable all segments
        for i in 0..<3 {
            segmentedControl.setEnabled(true, forSegmentAt: i)
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
            case .batchIO: // switch to batch mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForBatchIO
                currentMode = .batchIO
                simulatedIOMode = .batch
                UIView.animate(withDuration: animationDuration) {
                    self.inputTextView.isHidden = false
                    self.outputTextView.isHidden = false
                    self.terminalTextView.isHidden = true
                    self.memoryView.isHidden = true
                    self.inputLabel.isHidden = false
                    self.inputLabel.text = "Input"
                    self.outputLabel.isHidden = false
                }

                
            case .terminalIO: // switch to terminal mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForTerminalIO
                currentMode = .terminalIO
                simulatedIOMode = .terminal
                UIView.animate(withDuration: animationDuration) {
                    self.inputTextView.isHidden = true
                    self.outputTextView.isHidden = true
                    self.terminalTextView.isHidden = false
                    self.memoryView.isHidden = true
                    self.inputLabel.isHidden = false
                    self.inputLabel.text = "Terminal"
                    self.outputLabel.isHidden = true
                }
            case .memory:
                // switch to memory mode
                // set `segmentedControl`'s `selectedSegmentIndex` just in case `setMode` is called from outside
                segmentedControl.selectedSegmentIndex = segIdxForMemory
                currentMode = .memory
                // don't set the simulatedIOMode
                // but update the memory dump as contents may have been modified
                memoryView.update()
                UIView.animate(withDuration: animationDuration) {
                    self.inputTextView.isHidden = true
                    self.outputTextView.isHidden = true
                    self.terminalTextView.isHidden = true
                    self.memoryView.isHidden = false
                    self.inputLabel.isHidden = true
                    self.outputLabel.isHidden = false
                }
            }
        }
    }
    
    
    
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
