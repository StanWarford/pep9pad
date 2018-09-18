//
//  CPUViewController.swift
//  pep9pad
//
//  Created by David Nicholas on 9/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class CPUViewController: UIViewController {

    let drawingSize = CGRect(x: 0.0, y: 0.0, width: 840, height: 1024)
    
    lazy var currentCPUDisplay = CPU1ByteView(frame: drawingSize)
    
    var testBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCPU()
        setupCodeView()
        setupMemView()
    }
    
    
    // Button added in storyboard
    @IBOutlet var storyboardBtn: UIBarButtonItem!
    
    // Called when storyboardBtn senses a touch up inside.
    @IBAction func testNavbarBtnPressed(_ sender: Any) {
        print("storyboard button pressed")
    }
    
    
    /// This function adds a title and another button to the navigationItem.
    func setupNavBar() {
        self.navigationItem.title = "Test Title"
        
        
        // dynamically create and add a button
        self.testBtn = UIBarButtonItem(title: "DynamicallyAddedButton", style: .plain, target: self, action: #selector(self.btnPressed))
        
        UIView.animate(withDuration: 2.0) {
            self.navigationItem.leftBarButtonItems?.append(self.testBtn)
        }
    }
    
    // Called when the dynamically added button is pressed.
    @objc func btnPressed() {
        print("test button pressed")
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / currentCPUDisplay.bounds.width
        let heightScale = size.height / currentCPUDisplay.bounds.height
        let minScale = min(widthScale, heightScale)

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
        CPUScrollView.addSubview(currentCPUDisplay)
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
        return currentCPUDisplay
    }
}
