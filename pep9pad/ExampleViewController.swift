//
//  ExampleViewController.swift
//  pep9pad
//
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
    
    @IBOutlet weak var topTextView: CodeView!
    @IBOutlet weak var bottomTextView: CodeView!
    
    
    // MARK: - Methods
    
    func loadExample(_ fileName: String, field: ExampleVCTextField, ofType: PepFileType) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: ofType.rawValue) else {
            print("Could not load file named \(fileName).\(ofType.rawValue)")
            return
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            //print("Loaded file named \(fileName).\(ofType.rawValue)")
            let tempCodeView: CodeView
            
            switch field {
            case .Top:
                // the 'current example' is always the one on top
                tempCodeView = topTextView
                currentExampleText = content
                currentExampleType = exampleType(ofType)
            case .Bottom:
                //Displays Regardless, only want if bottom exists
                tempCodeView = bottomTextView
            }
            
            tempCodeView.setHighlight(ofType)
            tempCodeView.removeAllText()
            tempCodeView.setText(content)
        
            
            // scroll to top in both textViews
            topTextView.textView.setContentOffset(CGPoint.zero, animated: false)
            bottomTextView.textView.setContentOffset(CGPoint.zero, animated: false)

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
                //let newRectForBottom = CGRect(x: view.frame.origin.x, y: viewHeight, width: viewWidth, height: 0)
                UIView.animate(withDuration: 0.25) {
                    self.topTextView.frame = newRectForTop
                    self.bottomTextView.isHidden = true
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
                //Displays Regardless, only want for bottom
                UIView.animate(withDuration: 0.25) {
                    self.topTextView.frame = newRectForTop
                    self.bottomTextView.frame = newRectForBottom
                    self.bottomTextView.isHidden = false
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
    
    func exampleType(_ type: PepFileType) -> PepFileType {
        // little bit of complexity here, so I put it in a function
        // .pepb and .peph are treated as .pepo
        switch type {
        case .pepb, .peph, .pepo:
            return .pepo
        default:
            return type
        }
    }
    
    func makeBoarder() {
        topTextView!.layer.borderWidth = 1
        bottomTextView!.layer.borderColor = UIColor.black.cgColor
        bottomTextView!.layer.borderWidth = 1
        bottomTextView!.layer.borderColor = UIColor.black.cgColor
        
    }
    
    



}
