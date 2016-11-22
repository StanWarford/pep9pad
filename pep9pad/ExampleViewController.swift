//
//  ExampleViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/15/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit



enum ExampleVCTextField {
    case Top
    case Bottom
}



class ExampleViewController: UIViewController {
    
    internal var currentExampleText: String! = nil
    internal var currentExampleType: PepFileType! = nil
    internal var currentExampleIO: String! = nil
    internal var currentExampleRequiresTerminal: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextView.setupTextView(topTextView.bounds)
        bottomTextView.setupTextView(bottomTextView.bounds)
    }
    
    // MARK: - Interface
    
    @IBOutlet weak var topTextView: PepTextView!
    @IBOutlet weak var bottomTextView: PepTextView!
    
    
    // MARK: - Methods
    
    func loadExample(_ fileName: String, field: ExampleVCTextField, ofType: PepFileType) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: ofType.rawValue) else {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            print("Loaded file named \(fileName).\(ofType.rawValue)")
            
            switch field {
            case .Top:
                self.topTextView.textView.text.removeAll()
                self.topTextView.textView.insertText(content)
                self.currentExampleText = content
                if ofType == .pepb || ofType == .peph {
                    self.currentExampleType = .pepo
                } else {
                    self.currentExampleType = ofType
                }
            case .Bottom:
                self.bottomTextView.textView.text.removeAll()
                self.bottomTextView.textView.insertText(content)
            }

        } catch _ as NSError {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
    }
    
    
    
    /// Changes the view to show one or two textViews and scrolls the textViews back to the top.
    func setNumTextViews(to n: Int = 2) {
        if (n > 2 || n < 1) {
            // illegal number of textViews requested
            return
        } else {
            switch n {
            case 1:
                // grow topTextView to take up entire view, and shrink bottomTextView to height of 0
                let viewHeight = view.frame.height
                let viewWidth = view.frame.width
                let newRectForTop = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+navAndStatBarHeight, width: viewWidth, height: viewHeight-navAndStatBarHeight)
                let newRectForBottom = CGRect(x: view.frame.origin.x, y: viewHeight, width: viewWidth, height: 0)
                UIView.animate(withDuration: 0.25) {
                    self.topTextView.frame = newRectForTop
                    self.bottomTextView.frame = newRectForBottom
                }
                // scroll the textViews back to top
                topTextView.textView.setContentOffset(CGPoint.zero, animated: false)
                bottomTextView.textView.setContentOffset(CGPoint.zero, animated: false)
                
                
            case 2:
                // grow bottomTextView to take up half of view, and shrink topTextView to take up other half
                let viewHeight = view.frame.height
                let viewWidth = view.frame.width
                let heightOfEach = (viewHeight-navAndStatBarHeight)/2
                let newRectForTop = CGRect(x: view.frame.origin.x, y: view.frame.origin.y+navAndStatBarHeight, width: viewWidth, height: heightOfEach)
                let newRectForBottom = CGRect(x: view.frame.origin.x, y: viewHeight/2+navAndStatBarHeight/2, width: viewWidth, height: heightOfEach)
                UIView.animate(withDuration: 0.25) {
                    self.topTextView.frame = newRectForTop
                    self.bottomTextView.frame = newRectForBottom
                }
                // scroll the textViews back to top
                topTextView.textView.setContentOffset(CGPoint.zero, animated: false)
                bottomTextView.textView.setContentOffset(CGPoint.zero, animated: false)

            default:
                // should not get here
                break
            }
        }
    }
    
    
    func setExampleIO(_ s: String) {
        self.currentExampleIO = s
        self.currentExampleRequiresTerminal = false
    }
    
    func setExampleTerminalIO(_ s: String) {
        self.currentExampleIO = s
        self.currentExampleRequiresTerminal = true
        
    }




}
