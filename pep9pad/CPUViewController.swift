//
//  CPUViewController.swift
//  pep9pad
//
//  Created by David Nicholas on 9/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CPUViewController: UIViewController, keypadDelegate, SimulatorDelegate {
    var codeList: [CPUCode]!
    var cycleCount: Int!
    
    var codeLine = 0
    
    func backspacePressed( label: UILabel) {
        lineTable.scrollToRow(at: currentIndex, at: .middle, animated: true)
        let cell = lineTable.cellForRow(at: currentIndex) as? numericLineCell
        
        cell?.textField.text!.removeLast()
        cell?.editLineValue(self)

        cell?.editLineValue(self)
        label.text?.removeLast()
    }
    
    
    func keyPressed(value : String, label: UILabel) {
        lineTable.scrollToRow(at: currentIndex, at: .middle, animated: true)
        let cell = lineTable.cellForRow(at: currentIndex) as? numericLineCell
        
        cell?.textField.text! += value
        cell?.editLineValue(self)
        var stringVal = decControlToMnemonMap.keys.contains((cell?.line!)!) ? decControlToMnemonMap[(cell?.line)!] : memControlToMnemonMap[(cell?.line!)!]
        
        label.text = "MicroCode Equivalent: " + stringVal! + "=" + (cell?.textField.text!)!
        
    }
    
    
    func hideKeyboard() {
        let cell = lineTable.cellForRow(at: currentIndex) as? numericLineCell
        cell?.textField.resignFirstResponder()
        keypad.isHidden = true
        memView.isHidden = false
        
    }
    
    func showKeypad(){
        keypad.isHidden = false
        keypad.delegate = self
        memView.isHidden = true
        let cell = lineTable.cellForRow(at: currentIndex)
        cell?.setHighlighted(true, animated: false)
    }
    
    
    var currentIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    var microAssembler = CPUAssemblerModel()
   
    let clockCellId = "clock"
    let numericCellId = "number"
    
    let cpuHelper = CPUHelper()
    
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
    var lines = [String]()
    
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
        
        setupAssembler()
        
        initEnumMnemonMaps(currentBusSize: currentCPUSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lineTableView.addBorderTop()
        lineTableView.addBorderRight()
//        memory.addBorderTop()
//        memory.addBorderRight()
        memPadContainer.addBorderTop()
        memPadContainer.addBorderRight()
        codeEditor.superview?.addBorderRight()
       
        let border = CALayer()
        let thickness : CGFloat =  1.0
        //codeEditor.frame
        border.frame = CGRect(x: codeEditor.frame.width - thickness, y: 0, width: thickness, height: codeEditor.frame.height)
        border.backgroundColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.0).cgColor
        codeEditor.layer.addSublayer(border)
        
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
    @IBOutlet weak var memPadContainer: UIView!
    
    @IBOutlet weak var memView: UIView!
    @IBOutlet weak var keypad: keypad!
    
   // @IBOutlet weak var codeView: CodeView!
    @IBOutlet weak var codeEditor: CPUCodeEditor!
    @IBOutlet weak var lineTableView: LineTableView!
    @IBOutlet weak var CPUScrollView: UIScrollView!
    @IBOutlet weak var lineTable: UITableView!
    
    //Mark :- Set Up Funcs
    func setupAssembler(){
        //microAssembler = CPUAssemblerModel()
        microAssembler.sim = self
        cycleCount = 0
        codeList = [CPUCode]()
    }
    
    /// This function adds a title and another button to the navigationItem.
    func setupNavBar() {
        self.navigationItem.title = "Pep9 CPU"
        
        
        // dynamically create and add a button
        self.testBtn = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.btnPressed))
        
        UIView.animate(withDuration: 2.0) {
            self.navigationItem.leftBarButtonItems?.insert(self.testBtn, at: 0)
        }
    }
    func setupCPU(){
        CPUScrollView.contentSize = CGSize(width: 840, height: 1024)
        CPUScrollView.delegate = self
        CPUScrollView.addSubview(oneByteCPUDisplay)
        //CPUScrollView.superview!.addBorderLeft()
        
    }
//    func pullFromProjectModel() {
//        codeView.setText(cpuProjectModel.sourceStr)
//    }
    
//    func setupCodeView(){
//        let codeViewRect = CGRect(x: 0.0, y: 0.0, width: codeView.frame.width, height: codeView.frame.height)
//        codeView.setupTexstView(codeViewRect, delegate: self, highlightAs: .pep)
//        pullFromProjectModel()
//        codeView.textView.scrollRectToVisible(CGRect.zero, animated: true)
//    }
    
    func setupCodeEditor(){
        codeEditor.delegate = self
        codeEditor.backgroundColor = UIColor.white
        codeEditor.textColor = UIColor.black
        codeEditor.autocorrectionType = .no
        codeEditor.text = cpuProjectModel.sourceStr
        //codeEditor.inputView!.addBorderRight()
        //codeEditor.inputView?.addBorder()
        
    }
    func setupMemView(){
        keypad.isHidden = true
        memView.isHidden = false
        
        memoryView = (Bundle.main.loadNibNamed("MemoryHeader", owner: self, options: nil)![0] as! UIView as! MemoryView)
        memoryView.frame = CGRect(x: memPadContainer.frame.origin.x, y: 0.0, width: memPadContainer.frame.width, height: memPadContainer.frame.height-10)

        memoryView.pcBtn.isHidden = true
        memoryView.spBtn.isHidden = true
        memView.addSubview(memoryView)
//        memory.addSubview(memoryView)
      
        
    }
    
    func setupLineTableView(){
        lineTableView.masterVC = self
       
    }
    
    func setupLines(){
        if currentCPUSize == .oneByte{
            lines = ["LoadCk", "C","B","A","MARCk","MDRCk","AMux","MDRMux","CMux","ALU","CSMux","SCk","CCk","VCk","ZCk", "NCk","AndZ","MemWrite","MemRead"]
        }else{
            lines = ["LoadCk","C","B","A","MARMux","MARCk","MDROCk","MDROMux","MDRECk","MDREMux","EOMux","AMux","CMux","ALU","CSMux","SCk","CCk","VCk","ZCk", "NCk","AndZ","MemWrite","MemRead"]
        }
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
        let attrs = [NSAttributedStringKey.font: UIFont.fontAwesome(ofSize: ofSize)] as Dictionary
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
  
    @IBOutlet weak var stopBtn: UIBarButtonItem! {
        didSet{
             setButtonIcon(forBarBtnItem: self.stopBtn, nameOfIcon: .stop, ofSize: 20)
             stopBtn.isEnabled = false
        }
    }
    
    @IBOutlet weak var singleStepBtn: UIBarButtonItem!{
        didSet{
            singleStepBtn.isEnabled = false
            singleStepBtn.tintColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var resumeBtn: UIBarButtonItem!{
        didSet{
            resumeBtn.isEnabled = false
            resumeBtn.tintColor = UIColor.clear
        }
    }
    @IBOutlet weak var helpBtn: UIBarButtonItem!
    
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
   
    @IBAction func HelpBtnPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Help", bundle: Bundle.main).instantiateInitialViewController()
        cpuHelper.cpuMasterVC = self
        self.present(vc!, animated: true) {
            if let spvc = vc as! UISplitViewController? {
                let nav = spvc.viewControllers[0] as! UINavigationController
                let hm = nav.viewControllers[0] as! HelpMasterController
                //hm.setup(cpu: self)
                hm.setup(master: self.cpuHelper, tableDelegate: self.cpuHelper, dataSource: self.cpuHelper)
                
            }
        }
        
    }
    
    //var line = 0
    
    @IBAction func singleStepBtnPressed(_ sender: Any) {
        codeLine = oneByteCPUDisplay.singleStep()
        oneByteCPUDisplay.setNeedsDisplay()
        oneByteCPUDisplay.loadLine()
        
        
        

        highlightLine()
        
//        //line = line + 1
//        print(codeLine)
//        if codeLine == codeList.count{
//            //stopDebugging()
//        }else if codeLine == -1 {
//            print(oneByteCPUDisplay.errorMessage)
//        }

    }
    @IBAction func resumeBtnPressed(_ sender: Any) {
       
    }
    
    @IBAction func runBtnPressed(_ sender: Any) {
//        codeEditor.text += "\n"
//        cpuProjectModel.sourceStr = codeEditor.text
//        if microAssembler.microAssemble() {
//            // Do Sim Stuff
//            if currentCPUSize == .oneByte {
//                //oneByteCPUDisplay.simulate(codeList: codeList!, cycleCount: cycleCount!)
//                oneByteCPUDisplay.setNeedsDisplay()
//            }else{
//                //Two Byte Implementation
//            }
//        }else{
//
//        }
//
//        //CPUScrollView.subviews[0].setNeedsDisplay()
        let unitAlert = UnitAlert()
        //unitAlert.showAlert(masterVC: self, bgColor: UIColor.red, msg:"Failed to Pass Unit Post")
        unitAlert.showAlert(masterVC: self, bgColor: UIColor.CPUColors.bitBusColor, msg: "Passed Unit Post")
    }
    
    @IBAction func debugBtnPressed(_ sender: Any) {
        startDebugging()
    }
    
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        stopDebugging()
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
    
    var codeLineIndexes = [Int]()
    var textStorage : NSTextStorage!
    var lineRanges = [NSRange]()
    var indexOfLine = 0
    
    func findCodeLines(){
//        for index in 0..<codeList.count {
//            if codeList[index] is MicroCode {
//                codeLineIndexes.append(index)
            //}
        //}
        let codeText = codeEditor.text
        for rangeIndex in 0..<lineRanges.count {
            //ADD IF LET
            let range = Range(lineRanges[rangeIndex],in: textStorage.string)
            //let line = codeText?.substring(with: range!)
            let line = String((codeText?[range!])!)
            //CHECK HERE FOR LINE IS NIL
            let lineRange = NSRange(location: 0, length: line.count)
            
            if shouldHighlight(line: line, range: Range(lineRange, in: line)!){
                codeLineIndexes.append(rangeIndex)
            }
        }
    }
    
    func shouldHighlight(line : String, range : Range<String.Index>)->Bool{
        //check if blank
        if line == "" {
            return false
        }
        //comments
        let commentRegex = "//.*"
        if line.range(of: commentRegex, options: .regularExpression, range: range, locale: nil) != nil {
            return false
        }
        
        //unitpre and post
        let unitRegex = "unit.*"
        let lowercaseLine = line.lowercased() // to normalize the data for the regex
        if lowercaseLine.range(of: unitRegex, options: .regularExpression, range: range, locale: nil) != nil{
            return false
        }

        //Since we have assembeled everything is valid meaning only microcode lines will get this far
        //So we should highlight it
        return true
    }
    
    func setupLineHighlighter(){
        textStorage = codeEditor.textStorage  //textView.textStorage
        // Use NSString here because textStorage expects the kind of ranges returned by NSString,
        // not the kind of ranges returned by String.
                let storageString = textStorage.string as NSString
                lineRanges = [NSRange]()
               storageString.enumerateSubstrings(in: NSMakeRange(0, storageString.length), options: .byLines, using: { (_, lineRange, _, _) in
                    self.lineRanges.append(lineRange)
                })
        
    }
    
    func setBackgroundColor(_ color: UIColor?, forLine line: Int) {
        if let color = color {
//
            //textStorage.addAttribute(.backgroundColor, value: color, range: lineRanges[line])
            
            
            let attributedText = codeEditor.attributedText.mutableCopy() as! NSMutableAttributedString
            attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.CPUColors.aluColor, range: lineRanges[line])
                codeEditor.attributedText = (attributedText.copy() as! NSAttributedString)
        } else {
            //textStorage.removeAttribute(.backgroundColor, range: lineRanges[line])
            
            
            let attributedText = codeEditor.attributedText.mutableCopy() as! NSMutableAttributedString
                attributedText.removeAttribute(NSAttributedString.Key.backgroundColor, range: lineRanges[line])
            codeEditor.attributedText = (attributedText.copy() as! NSAttributedString)
        }
    }
    
    func highlightLine(){
        if indexOfLine > 0 {
            setBackgroundColor(nil, forLine: codeLineIndexes[indexOfLine - 1])
        }
        
        if indexOfLine < codeLineIndexes.count{
            setBackgroundColor(.blue, forLine: codeLineIndexes[indexOfLine])
            codeEditor.invalidateCachedParagraphs()
            indexOfLine += 1
        }
        
        
//        if index > 0 {
//            setBackgroundColor(nil, forLine: codeLineIndexes[index - 1])
//        }
//         setBackgroundColor(.blue, forLine: codeLineIndexes[index])
//
//
//
//        func scheduleHighlighting(ofLine line: Int) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                if line > 0 { setBackgroundColor(nil, forLine: line - 1) }
//                guard line < lineRanges.count else { return }
//                setBackgroundColor(.yellow, forLine: line)
//                scheduleHighlighting(ofLine: line + 1)
//            }
//        }
//
//        scheduleHighlighting(ofLine: 0)
        
        
//        var firstNewLine = index-1
//
//        var startIndex = 0
//        var endIndex = 0
//
//        for i in 0..<codeEditor.text!.count {
//            if codeEditor.text[i] == "\n"{
//                if firstNewLine == 1{
//                    startIndex = i
//                    firstNewLine = firstNewLine - 1
//                }else if firstNewLine == 0{
//                    endIndex = i
//                    break
//                }else{
//                    firstNewLine = firstNewLine - 1
//                }
//            }
//        }
//        let attributedText = codeEditor.attributedText.mutableCopy() as! NSMutableAttributedString
//        let attributedRange = NSRange(location: 0, length: attributedText.length)
//        let newRange = NSRange(location: startIndex+1, length: endIndex-startIndex)
//
//        //remove stuff
//        attributedText.removeAttribute(NSAttributedString.Key.backgroundColor, range: attributedRange)
//        //attributedText.removeAttribute(NSAttributedString.Key.foregroundColor, range: attributedRange)
//
//        attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.CPUColors.aluColor, range: newRange)
//        //attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: newRange)
//
//        codeEditor.attributedText = (attributedText.copy() as! NSAttributedString)
        
    }
    
    func loadExample(text : String){
        codeEditor.text.removeAll()
        var code = text.replacingOccurrences(of: "\\d*\\. ", with: "", options: .regularExpression)
        //Makes it so there isn't an extra line (fixes numbering)
        code.removeLast()
        codeEditor.text = code
        codeEditor.pepHighlighter(busSize: currentCPUSize)
        codeEditor.delegate?.textViewDidChange!(codeEditor)
    }
    
    func startDebugging(){
        // Toggle Buttons
        singleStepBtn.isEnabled = true
        singleStepBtn.tintColor = nil
        
        resumeBtn.isEnabled = true
        resumeBtn.tintColor = nil
        
        debugBtn.isEnabled = false
        runBtn.isEnabled = false
        stopBtn.isEnabled = true
        
        
            //codeEditor.text += "\n"
            cpuProjectModel.sourceStr = codeEditor.text
            if microAssembler.microAssemble() {
                oneByteCPUDisplay.loadSimulator(codeList: codeList!, cycleCount: cycleCount!, memView: memoryView)
                oneByteCPUDisplay.loadLine()
                setupLineHighlighter()
                findCodeLines()
                highlightLine()
                
                oneByteCPUDisplay.setNeedsDisplay()
            }else{
                //Errors
            }
        
        
    }
    func stopDebugging(){
        singleStepBtn.isEnabled = false
        singleStepBtn.tintColor = UIColor.clear
        
        resumeBtn.isEnabled = false
        resumeBtn.tintColor = UIColor.clear
        
        debugBtn.isEnabled = true
        runBtn.isEnabled = true
        stopBtn.isEnabled = false

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
        codeEditor.pepHighlighter(busSize: currentCPUSize)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath
//        showKeypad()
//        print(currentIndex)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let line = lines[indexPath.row]
        if mnemonToMemControlMap.keys.contains(line.uppercased()) || mnemonToDecControlMap.keys.contains(line.uppercased()){
            let cell = tableView.dequeueReusableCell(withIdentifier: numericCellId, for: indexPath) as! numericLineCell
            cell.lineName.text = line
            cell.line = mnemonToMemControlMap.keys.contains(line.uppercased()) ?
                mnemonToMemControlMap[line.uppercased()]! :
                mnemonToDecControlMap[line.uppercased()]!
            
            cell.textField.text = copyMicroCodeLine[cell.line] == -1 ? "" : String(copyMicroCodeLine[cell.line]!)
            cell.delegate = self
            cell.cellIndex = indexPath
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: clockCellId, for: indexPath) as! clockLineCell
            
            cell.lineName.text = line
            cell.line = mnemonToClockControlMap[line.uppercased()]!
            cell.lineActive = copyMicroCodeLine[cell.line] == -1 ? false : true
            let buttonTitle = cell.lineActive ? "✓" : ""
            cell.checkbox.setTitle(buttonTitle, for: .normal)
            
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
    
    func setCurrentIndex(index : IndexPath) {
        let cell = lineTable.cellForRow(at: currentIndex)
        cell?.setHighlighted(false, animated: false)
        currentIndex = index
        showKeypad()
        
    }
    
    
    
}


extension CPUViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        codeEditor.invalidateCachedParagraphs()
        if let selectedRange = codeEditor.selectedTextRange {
            let cursorPosition = codeEditor.offset(from: codeEditor.beginningOfDocument, to: selectedRange.start)
            
//            for char in codeEditor.text{
//
//            }
            print("\(cursorPosition)")
        }
//        if codeEditor.text.last == " " || codeEditor.text.last == "," {
//            //codeEditor.pepHighlighter(busSize: currentCPUSize)
//        }
        codeEditor.setNeedsDisplay()
        
//        let border = CALayer()
//        let thickness : CGFloat =  1.0
//        //codeEditor.frame
//        border.frame = CGRect(x: codeEditor.frame.width - thickness, y: 0, width: thickness, height: codeEditor.frame.height)
//        border.backgroundColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.0).cgColor
//
//        codeEditor.layer.addSublayer(border)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        codeEditor.invalidateCachedParagraphs()
        //codeEditor.pepHighlighter(busSize: currentCPUSize)
        
//        let border = CALayer()
//        let thickness : CGFloat =  1.0
//        //codeEditor.frame
//        border.frame = CGRect(x: codeEditor.frame.width - thickness, y: 0, width: thickness, height: codeEditor.frame.height)
//        border.backgroundColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.0).cgColor
//
//        //codeEditor.layer.addSublayer(border)
//        codeEditor.layer.replaceSublayer((codeEditor.layer.sublayers?[0])!, with: border)
        //
        //
        //codeEditor.view
        codeEditor.setNeedsDisplay()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        codeEditor.pepHighlighter(busSize: currentCPUSize)
    }
    
    
}
