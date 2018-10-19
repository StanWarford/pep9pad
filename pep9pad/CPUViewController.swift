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

    let clockCellId = "clock"
    let numericCellId = "number"
    
    let drawingOneByteSize = CGRect(x: 0.0, y: 0.0, width: 950, height: 1024)
    let drawingTwoByteSize = CGRect(x: 0.0, y: 0.0, width: 2000, height: 2000)
    
    lazy var oneByteCPUDisplay = CPU1ByteView(frame: drawingOneByteSize)
    lazy var twoByteCPUDisplay = CPU2ByteView(frame: drawingTwoByteSize)
    var currentCPUSize = CPUBusSize.oneByte // default bus view
    
    //For CopyToMicroCode
    var copyMicroCodeLine : [CPUEMnemonic : Int] = [:]
    
    internal let byteCalc = ByteCalc()
    internal let fontMenu = FontMenu()
    internal let debugMenu = DebugMenu()
    internal let mailer = Pep9Mailer()
    internal let unaryMnemonics = UnaryMnemonics()
    internal let nonunaryMnemonics = NonunaryMnemonics()
    var testBtn: UIBarButtonItem!
    
    //For Table
    var lines = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupCPU()
        //setupCodeView()
        setupCodeEditor()
        setupMemView()
        setupLineTableView()
        setupLines()
        setupLineTable()
        setupCopyMicroCodeLine()
       
        initEnumMnemonMaps(currentBusSize: currentCPUSize)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(CPUScrollView.bounds.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark:- Vars for Views
    var memoryView : MemoryView!
    @IBOutlet weak var memory: UIView!
   // @IBOutlet weak var codeView: CodeView!
    @IBOutlet weak var codeEditor: CPUCodeEditor!
    @IBOutlet weak var lineTableView: LineTableView!
    @IBOutlet weak var CPUScrollView: UIScrollView!
    @IBOutlet weak var lineTable: UITableView!
    
    //Mark :- Set Up Funcs
    /// This function adds a title and another button to the navigationItem.
    func setupNavBar() {
        self.navigationItem.title = "Pep9 CPU"
        
        
        // dynamically create and add a button
        self.testBtn = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.btnPressed))
        
        UIView.animate(withDuration: 2.0) {
            self.navigationItem.leftBarButtonItems?.append(self.testBtn)
        }
    }
    func setupCPU(){
        CPUScrollView.contentSize = CGSize(width: 840, height: 1024)
        CPUScrollView.delegate = self
        CPUScrollView.addSubview(oneByteCPUDisplay)
    }
//    func pullFromProjectModel() {
//        codeView.setText(cpuProjectModel.sourceStr)
//    }
    
//    func setupCodeView(){
//        let codeViewRect = CGRect(x: 0.0, y: 0.0, width: codeView.frame.width, height: codeView.frame.height)
//        codeView.setupTextView(codeViewRect, delegate: self, highlightAs: .pep)
//        pullFromProjectModel()
//        codeView.textView.scrollRectToVisible(CGRect.zero, animated: true)
//    }
    
    func setupCodeEditor(){
        codeEditor.delegate = self
        codeEditor.backgroundColor = UIColor.white
        codeEditor.textColor = UIColor.black
    }
    func setupMemView(){
        memoryView = Bundle.main.loadNibNamed("MemoryHeader", owner: self, options: nil)![0] as! UIView as! MemoryView
        memoryView.frame = CGRect(x: memory.frame.origin.x, y: 0.0, width: memory.frame.width,
                                  height: memory.frame.height-10)
        
        memoryView.pcBtn.isHidden = true
        memoryView.spBtn.isHidden = true
        memory.addSubview(memoryView)
        
    }
    
    func setupLineTableView(){
        lineTableView.masterVC = self
    }
    
    func setupLines(){
        
        let decControlLines : [String]
        if currentCPUSize == .oneByte{
            decControlLines = ["C","B","A","AMux","MDRMux","CMux","ALU","CSMux","AndZ","MemWrite","MemRead"]
        }else{
            decControlLines = ["C","B","A","MARMux","MDROMux","MDREMux","EOMux","AMux","CMux","ALU","CSMux","AndZ","MemWrite","MemRead"]
        }
        
        let clockControlLines : [String]
        if currentCPUSize == .oneByte{
           clockControlLines = ["LoadCk", "MARCk","MDRCk","SCk","CCk","VCk","ZCk", "NCk"]
        }else{
           clockControlLines = ["LoadCk", "MARCk","MDROCk","MDRECk","SCk","CCk","VCk","ZCk", "NCk"]
        }
        
        lines = [decControlLines,clockControlLines]
    }
    
    func setupLineTable(){
        
        lineTable.dataSource = self
        lineTable.delegate = self
    }
    
    func setupCopyMicroCodeLine(){
        copyMicroCodeLine[.LoadCk] = -1
        copyMicroCodeLine[.C ] = -1
        copyMicroCodeLine[.B] = -1
        copyMicroCodeLine[.A] = -1
        copyMicroCodeLine[.MARCk] = -1
        if currentCPUSize == .oneByte{
            copyMicroCodeLine[.MDRCk] = -1
        }else{
             copyMicroCodeLine[.MDROCk] = -1
             copyMicroCodeLine[.MDRECk] = -1
        }
        copyMicroCodeLine[.AMux] = -1
        if currentCPUSize == .oneByte{
             copyMicroCodeLine[.MDRMux] = -1
        }else{
            copyMicroCodeLine[.MARMux] = -1
            copyMicroCodeLine[.MDROMux] = -1
            copyMicroCodeLine[.MDREMux] = -1
            copyMicroCodeLine[.EOMux] = -1
        }
        copyMicroCodeLine[.CMux] = -1
        copyMicroCodeLine[.ALU] = -1
        copyMicroCodeLine[.CSMux] = -1
        copyMicroCodeLine[.SCk] = -1
        copyMicroCodeLine[.CCk] = -1
        copyMicroCodeLine[.VCk] = -1
        copyMicroCodeLine[.AndZ] = -1
        copyMicroCodeLine[.ZCk] = -1
        copyMicroCodeLine[.NCk] = -1
        copyMicroCodeLine[.MemWrite] = -1
        copyMicroCodeLine[.MemRead] = -1
    }
    
    /// Convenience function that sets the `title` property of a `UIBarButtonItem` to a `FontAwesome` icon.
    func setButtonIcon(forBarBtnItem btn: UIBarButtonItem, nameOfIcon: FontAwesome, ofSize: CGFloat) {
        let attrs = [NSAttributedStringKey.font: UIFont.fontAwesome(ofSize: ofSize)] as Dictionary!
        btn.setTitleTextAttributes(attrs, for: .normal)
        btn.setTitleTextAttributes(attrs, for: .disabled)
        btn.setTitleTextAttributes(attrs, for: .highlighted)
        btn.title = String.fontAwesomeIcon(name: nameOfIcon)
    }
    
    // Mark:- Nav bar buttons
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
    
    // Mark:- Button Funcs
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

    }
    
    @IBAction func runBtnPressed(_ sender: Any) {
        //print(codeEditor.text)
       cpuProjectModel.sourceStr = codeEditor.text
        cpuAssembler.microAssemble()
        CPUScrollView.subviews[0].setNeedsDisplay()
//        let subViews = CPUScrollView.subviews
//        for subview in subViews{
//            subview.removeFromSuperview()
//        }
//        oneByteCPUDisplay.re
//        CPUScrollView.contentSize = CGSize(width: 840, height: 1024)
//        CPUScrollView.addSubview(oneByteCPUDisplay)
    }
    
    
    
    
    
    
    // Called when the dynamically added button is pressed.
    @objc func btnPressed() {
            //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
    }
    
    // Mark: - File Private Funcs
    
    fileprivate func switchToBus(_ size: CPUBusSize) {
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
            initEnumMnemonMaps(currentBusSize: currentCPUSize)
            setupCopyMicroCodeLine()
            setupLines()
            lineTable.reloadData()
        } else {
            print("no CPU change necessary")
        }
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

        CPUScrollView.minimumZoomScale = minScale
        CPUScrollView.maximumZoomScale = 1.5
        CPUScrollView.zoomScale = minScale
    }
    
    func copyToMicroCode(){
        //Order Matters
        var microCodeLine = ""
        
        microCodeLine += copyMicroCodeLine[.MemRead] == -1 ? "" : memControlToMnemonMap[.MemRead]! + ", "
        microCodeLine += copyMicroCodeLine[.MemWrite] == -1 ? "" : memControlToMnemonMap[.MemWrite]! + ", "
        
        microCodeLine += copyMicroCodeLine[.A] == -1 ? "" :  decControlToMnemonMap[.A]! + "=" + String(copyMicroCodeLine[.A]!) + ", "
        microCodeLine += copyMicroCodeLine[.B] == -1 ? "" :  decControlToMnemonMap[.B]! + "=" + String(copyMicroCodeLine[.B]!) + ", "
        
        if currentCPUSize == .twoByte{
            microCodeLine += copyMicroCodeLine[.MARMux] == -1 ? "" :  decControlToMnemonMap[.MARMux]! + "=" + String(copyMicroCodeLine[.MARMux]!) + ", "
            microCodeLine += copyMicroCodeLine[.EOMux] == -1 ? "" :  decControlToMnemonMap[.EOMux]! + "=" + String(copyMicroCodeLine[.EOMux]!) + ", "
        }
        
        microCodeLine += copyMicroCodeLine[.AMux] == -1 ? "" :  decControlToMnemonMap[.AMux]! + "=" + String(copyMicroCodeLine[.AMux]!) + ", "
        microCodeLine += copyMicroCodeLine[.CSMux] == -1 ? "" :  decControlToMnemonMap[.CSMux]! + "=" + String(copyMicroCodeLine[.CSMux]!) + ", "
        microCodeLine += copyMicroCodeLine[.ALU] == -1 ? "" :  decControlToMnemonMap[.ALU]! + "=" + String(copyMicroCodeLine[.ALU]!) + ", "
        microCodeLine += copyMicroCodeLine[.AndZ] == -1 ? "" :  decControlToMnemonMap[.AndZ]! + "=" + String(copyMicroCodeLine[.AndZ]!) + ", "
        microCodeLine += copyMicroCodeLine[.CMux] == -1 ? "" :  decControlToMnemonMap[.CMux]! + "=" + String(copyMicroCodeLine[.CMux]!) + ", "
        
        if currentCPUSize == .oneByte{
             microCodeLine += copyMicroCodeLine[.MDRMux] == -1 ? "" :  decControlToMnemonMap[.MDRMux]! + "=" + String(copyMicroCodeLine[.MDRMux]!) + ", "
        }else{
            microCodeLine += copyMicroCodeLine[.MDROMux] == -1 ? "" :  decControlToMnemonMap[.MDROMux]! + "=" + String(copyMicroCodeLine[.MDROMux]!) + ", "
            microCodeLine += copyMicroCodeLine[.MDREMux] == -1 ? "" :  decControlToMnemonMap[.MDREMux]! + "=" + String(copyMicroCodeLine[.MDREMux]!) + ", "
        }

        microCodeLine += copyMicroCodeLine[.C] == -1 ? "" :  decControlToMnemonMap[.C]! + "=" + String(copyMicroCodeLine[.C]!) + "; "
        //Ck
        microCodeLine += copyMicroCodeLine[.NCk] == -1 ? "" :  clockControlToMnemonMap[.NCk]! + ", "
        microCodeLine += copyMicroCodeLine[.ZCk] == -1 ? "" :  clockControlToMnemonMap[.ZCk]! + ", "
        microCodeLine += copyMicroCodeLine[.VCk] == -1 ? "" :  clockControlToMnemonMap[.VCk]! + ", "
        microCodeLine += copyMicroCodeLine[.CCk] == -1 ? "" :  clockControlToMnemonMap[.CCk]! + ", "
        microCodeLine += copyMicroCodeLine[.SCk] == -1 ? "" :  clockControlToMnemonMap[.SCk]! + ", "
        microCodeLine += copyMicroCodeLine[.MARCk] == -1 ? "" :  clockControlToMnemonMap[.MARCk]! + ", "
        microCodeLine += copyMicroCodeLine[.LoadCk] == -1 ? "" :  clockControlToMnemonMap[.LoadCk]! + ", "
        
        if currentCPUSize == .oneByte{
            microCodeLine += copyMicroCodeLine[.MDRCk] == -1 ? "" :  clockControlToMnemonMap[.MDRCk]!
        }else{
            microCodeLine += copyMicroCodeLine[.MDRECk] == -1 ? "" :  clockControlToMnemonMap[.MDRECk]! + ", "
            microCodeLine += copyMicroCodeLine[.MDROCk] == -1 ? "" :  clockControlToMnemonMap[.MDROCk]!
        }

        microCodeLine += "\n"
        
        codeEditor.text += microCodeLine
        codeEditor.invalidateCachedParagraphs()
        codeEditor.setNeedsDisplay()
    }

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

extension CPUViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = (section == 0 ? "Numeric Entries" : "Clock Lines")
        label.backgroundColor = UIColor.CPUColors.aluColor
        label.textAlignment = .center
        return label
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return lines.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        return lines[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: clockCellId, for: indexPath) as! clockLineCell
//        cell.lineName.text = "HI"
//
//        return cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: numericCellId, for: indexPath) as! numericLineCell
            //cell.textField.text = ""
            cell.lineName.text = lines[indexPath.section][indexPath.row]
            
            cell.line = mnemonToMemControlMap.keys.contains(lines[indexPath.section][indexPath.row].uppercased()) ?
                mnemonToMemControlMap[lines[indexPath.section][indexPath.row].uppercased()]! :
                mnemonToDecControlMap[lines[indexPath.section][indexPath.row].uppercased()]!
            
           cell.delegate = self
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: clockCellId, for: indexPath) as! clockLineCell

            cell.lineName.text = lines[indexPath.section][indexPath.row]
            cell.line = mnemonToClockControlMap[lines[indexPath.section][indexPath.row].uppercased()]!
            cell.delegate = self
            return cell
        }
   }

    
}


extension CPUViewController : LineTableDelegate{
    
    func updateCPU(element: CPUEMnemonic, value: String) {
        if currentCPUSize == .oneByte{
            oneByteCPUDisplay.updateCPU(line: element, value: value)
            oneByteCPUDisplay.setNeedsDisplay()
        }else{
            // TWO BYTE IMPLEMENTATION
        }
        
    }
    
    
    
}


extension CPUViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        codeEditor.invalidateCachedParagraphs()
        codeEditor.setNeedsDisplay()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        codeEditor.invalidateCachedParagraphs()
        codeEditor.setNeedsDisplay()
    }
}
