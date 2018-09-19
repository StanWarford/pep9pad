//
//  CPUViewController.swift
//  pep9pad
//
//  Created by David Nicholas on 9/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CPUViewController: UIViewController {

    let drawingOneByteSize = CGRect(x: 0.0, y: 0.0, width: 840, height: 1024)
    let drawingTwoByteSize = CGRect(x: 0.0, y: 0.0, width: 2000, height: 2000)
    
    lazy var oneByteCPUDisplay = CPU1ByteView(frame: drawingOneByteSize)
    lazy var twoByteCPUDisplay = CPU2ByteView(frame: drawingTwoByteSize)
    var currentCPUSize = CPUBusSize.oneByte // default bus view
    
    internal let byteCalc = ByteCalc()
    internal let fontMenu = FontMenu()
    internal let debugMenu = DebugMenu()
    internal let mailer = Pep9Mailer()
    internal let unaryMnemonics = UnaryMnemonics()
    internal let nonunaryMnemonics = NonunaryMnemonics()
    var testBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCPU()
        setupCodeView()
        setupMemView()
    }
    
    /// Convenience function that sets the `title` property of a `UIBarButtonItem` to a `FontAwesome` icon.
    func setButtonIcon(forBarBtnItem btn: UIBarButtonItem, nameOfIcon: FontAwesome, ofSize: CGFloat) {
        let attrs = [NSAttributedStringKey.font: UIFont.fontAwesome(ofSize: ofSize)] as Dictionary!
        btn.setTitleTextAttributes(attrs, for: .normal)
        btn.setTitleTextAttributes(attrs, for: .disabled)
        btn.setTitleTextAttributes(attrs, for: .highlighted)
        btn.title = String.fontAwesomeIcon(name: nameOfIcon)
    }
    
    // Button added in storyboard
    @IBOutlet var storyboardBtn: UIBarButtonItem!
   
    
    
    @IBOutlet var runBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.runBtn, nameOfIcon: .play, ofSize: 20)
        }
    }
    @IBOutlet var debugBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.debugBtn, nameOfIcon: .bug, ofSize: 20)
        }
    }
    @IBOutlet var stop: UIBarButtonItem! {
        didSet {
            self.stop.image = UIImage(named: "ham")
        }
    }
    @IBOutlet var calcBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.calcBtn, nameOfIcon: .calculator, ofSize: 20)
        }
    }
    @IBOutlet var settingsBtn: UIBarButtonItem! {
        didSet {
            setButtonIcon(forBarBtnItem: self.settingsBtn, nameOfIcon: .cog, ofSize: 20)
        }
    }
    
    @IBOutlet weak var fontBtn: UIBarButtonItem!
    
    @IBAction func fontBtnPressed(_ sender: UIBarButtonItem) {
        let fontMenu = self.fontMenu.makeAlert(barButton: sender)
        self.present(fontMenu, animated: true, completion: nil)
    }
    
    @IBAction func calcBtnPressed(_ sender: UIBarButtonItem) {
        let calcAlert = byteCalc.makeAlert()
        self.present(calcAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func busBtnPressed(_ sender: UIBarButtonItem) {
        
        var alertController: UIAlertController
        
        switch currentCPUSize {
        case .oneByte:
            alertController = UIAlertController(title: nil, message: "You're using the one-byte bus.", preferredStyle: .actionSheet)
            let twoByteAction = UIAlertAction(title: "Switch to two-byte bus", style: .default) { (action) in self.switchToBus(.twoByte) }
            
            alertController.addAction(twoByteAction)
        case .twoByte:
            alertController = UIAlertController(title: nil, message: "You're using the two-byte bus.", preferredStyle: .actionSheet)
            let oneByteAction = UIAlertAction(title: "Switch to one-byte bus", style: .default) { (action) in self.switchToBus(.oneByte)}
            
            alertController.addAction(oneByteAction)
        }
        
        alertController.popoverPresentationController?.barButtonItem = sender
        self.present(alertController, animated: true, completion: nil)
        
//        if cpuView.busSize == .oneByte {
//            alertController = UIAlertController(title: nil, message: "You're using the one-byte bus.", preferredStyle: .actionSheet)
//
//            let twoByteAction = UIAlertAction(title: "Switch to two-byte bus", style: .default) { (action) in
//                self.switchToBus(.twoByte)
//            }
//            alertController.addAction(twoByteAction)
//        } else {
//            alertController = UIAlertController(title: nil, message: "You're using the two-byte bus.", preferredStyle: .actionSheet)
//            let oneByteAction = UIAlertAction(title: "Switch to one-byte bus", style: .default) { (action) in
//                self.switchToBus(.oneByte)
//            }
//            alertController.addAction(oneByteAction)
//
//        }
//
//
//        alertController.popoverPresentationController?.barButtonItem = sender
//        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func switchToBus(_ size: CPUBusSize) {
        if size != currentCPUSize {
            // change the global instance
            //changeBusInstance(toSize: ofSize)
            let subViews = CPUScrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
            //        CPUScrollView.maximumZoomScale = 2.0
            //        CPUScrollView.minimumZoomScale = 0.25
            CPUScrollView.delegate = self
            
            switch currentCPUSize{
            case .oneByte:
               // CPUScrollView.willRemoveSubview(oneByteCPUDisplay)
                CPUScrollView.contentSize = CGSize(width: 2000, height: 2000)
                CPUScrollView.addSubview(twoByteCPUDisplay)
                currentCPUSize = .twoByte
            case .twoByte:
               // CPUScrollView.willRemoveSubview(twoByteCPUDisplay)
                CPUScrollView.contentSize = CGSize(width: 840, height: 1024)
                CPUScrollView.addSubview(oneByteCPUDisplay)
                currentCPUSize = .oneByte
            }
            
        } else {
            print("no CPU change necessary")
        }
    }
    
    
    
    
    
    // Called when storyboardBtn senses a touch up inside.
    @IBAction func testNavbarBtnPressed(_ sender: Any) {
        print("storyboard button pressed")
    }
    
    
    /// This function adds a title and another button to the navigationItem.
    func setupNavBar() {
        self.navigationItem.title = "Test Title"
        
        
        // dynamically create and add a button
        self.testBtn = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.btnPressed))
        
        UIView.animate(withDuration: 2.0) {
            self.navigationItem.leftBarButtonItems?.append(self.testBtn)
        }
    }
    
    // Called when the dynamically added button is pressed.
    @objc func btnPressed() {
            //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        
        var widthScale : CGFloat
        var heightScale : CGFloat
        var minScale : CGFloat
        
        switch currentCPUSize {
        case .oneByte:
                widthScale = size.width / oneByteCPUDisplay.bounds.width
                heightScale = size.height / oneByteCPUDisplay.bounds.height
                minScale = min(widthScale, heightScale)
        case .twoByte:
                widthScale = size.width / twoByteCPUDisplay.bounds.width
                heightScale = size.height / twoByteCPUDisplay.bounds.height
                minScale = min(widthScale, heightScale)
        }
//        let widthScale = size.width / oneByteCPUDisplay.bounds.width
//        let heightScale = size.height / oneByteCPUDisplay.bounds.height
//        let minScale = min(widthScale, heightScale)

        CPUScrollView.minimumZoomScale = minScale
        CPUScrollView.zoomScale = minScale
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(CPUScrollView.bounds.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var memoryView : MemoryView!
    @IBOutlet weak var memory: UIView!
    @IBOutlet weak var codeView: CodeView!
    @IBOutlet weak var CPUScrollView: UIScrollView!
    
    func setupCPU(){
        CPUScrollView.contentSize = CGSize(width: 840, height: 1024)
//        CPUScrollView.maximumZoomScale = 2.0
//        CPUScrollView.minimumZoomScale = 0.25
        CPUScrollView.delegate = self
        CPUScrollView.addSubview(oneByteCPUDisplay)
    }
    func pullFromProjectModel() {
        codeView.setText(projectModel.sourceStr)
    }
    
    func setupCodeView(){
        let codeViewRect = CGRect(x: 0.0, y: 0.0, width: codeView.frame.width, height: codeView.frame.height)
        codeView.setupTextView(codeViewRect, delegate: self, highlightAs: .pep)
        pullFromProjectModel()
        codeView.textView.scrollRectToVisible(CGRect.zero, animated: true)
        //codeView.setupTextView(codeViewRect)
        
//        let rectForCode = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height-heightOfTabBar)
//        textView.setupTextView(rectForCode, delegate: self, highlightAs: .pep)
//        pullFromProjectModel()
//        // scrolls the textview to the top...?
//        textView.textView.scrollRectToVisible(CGRect.zero, animated: true)
        
    }
    func setupMemView(){
        memoryView = Bundle.main.loadNibNamed("MemoryHeader", owner: self, options: nil)![0] as! UIView as! MemoryView
        memoryView.frame = CGRect(x: memory.frame.origin.x, y: 0.0, width: memory.frame.width,
            height: memory.frame.height-10)

        memoryView.pcBtn.isHidden = true
        memoryView.spBtn.isHidden = true
        memory.addSubview(memoryView)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CPUViewController : CodeViewDelegate{
    func textViewDidChange() {
        // Add Later
        return
    }
}

extension CPUViewController : UIScrollViewDelegate {
    //viewForZoomingInScrollView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return currentCPUSize == .oneByte ? oneByteCPUDisplay : twoByteCPUDisplay
    }
}
