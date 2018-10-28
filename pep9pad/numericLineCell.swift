//
//  numericLineCell.swift
//  pep9pad
//
//  Created by David Nicholas on 10/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

@IBDesignable
class numericLineCell: UITableViewCell {
    var line : CPUEMnemonic!
    var delegate : LineTableDelegate!
    var cellIndex : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.borderWidth = 0.5
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.autocorrectionType = UITextAutocorrectionType.no
            let items = textField.inputAssistantItem
            items.leadingBarButtonGroups = []
            items.trailingBarButtonGroups = []
            let tempView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
            textField.inputView = tempView
            textField.delegate = self
        }
    }
    @IBAction func editLineValue(_ sender: Any) {
        let text = textField.text!
        let value = Int(text) == nil ? -1 : Int(text)
        let isAlu = line == .ALU
        let bus = line == .A || line == .B || line == .C
        
        if text == "" || (isAlu && 0 <= value! && value! <= 15){
            textField.textColor = UIColor.black
            delegate.copyMicroCodeLine[line] = text == "" ? -1 : value
            delegate.updateCPU(element: line, value: text)
        }else if text == "" || bus && value! >= 0 && value! <= 31{
            textField.textColor = UIColor.black
            delegate.copyMicroCodeLine[line] = text == "" ? -1 : value
            delegate.updateCPU(element: line, value: text)
        }else if text == "" || value! >= 0 && value! <= 1{
            textField.textColor = UIColor.black
            delegate.copyMicroCodeLine[line] = text == "" ? -1 : value
            delegate.updateCPU(element: line, value: text)
        }else{
            //textField.textColor = UIColor.red
            textField.text?.removeLast()
        }
       
    
    }
    @IBAction func changeLineValue(_ sender: Any) {
        
    }
    @IBOutlet weak var lineName: UILabel!
    
}

extension numericLineCell : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //textField.resignFirstResponder()
        
        delegate.setCurrentIndex(index: cellIndex)
    }
    
    
}
