//
//  CPUHelper.swift
//  pep9pad
//
//  Created by David Nicholas on 11/14/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation
import UIKit

class CPUHelper : NSObject, HelpDelegate, UITableViewDelegate, UITableViewDataSource {
    var cpuMasterVC : CPUViewController!
    
    var exampleVC: ExampleViewController!
    
    var documentationVC: DocumentationViewController!
    
    var helpDetail: HelpDetailController!
    
    func loadDefault(){
        loadDocumentation(.UsingCPU)
    }
    
    func loadDocumentation(_ doc: Documentation) {
        documentationVC.view.isHidden = false
        exampleVC.view.isHidden = true
        
        let url = Bundle.main.url(forResource: doc.rawValue, withExtension:"html")
        let request = URLRequest(url: url!)
        documentationVC.doc.loadRequest(request)
        
        exampleVC.topTextView.setEditable(false)
        exampleVC.bottomTextView.setEditable(false)
    }
    
    func loadExample(_ named: String) -> String {
        documentationVC.view.isHidden = true
        exampleVC.view.isHidden = false
        
        switch named {
        case "Figure 12.05":
            exampleVC.loadExample("fig1205", field: .Top, ofType: .pep)
            exampleVC.setNumTextViews(to: 1)
            exampleVC.bottomTextView.removeAllText()
        default:
            exampleVC.topTextView.removeAllText()
            exampleVC.bottomTextView.removeAllText()
            exampleVC.setNumTextViews(to: 2)
        }
        
        return "Copy To Microcode"
    }
    
    func loadExampleToProj(_ text: String!, ofType: PepFileType!, io: String!, usesTerminal: Bool!) {
        print("load EX to Proj")
    }
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: Set selection style for cells
        
        var v: UITableViewCell
        if let aPreexistingCell = tableView.dequeueReusableCell(withIdentifier: "helpID") {
            v = aPreexistingCell
        } else {
            v = UITableViewCell(style: .subtitle, reuseIdentifier: "helpID")
        }
        
        v.detailTextLabel?.lineBreakMode = .byWordWrapping
        v.detailTextLabel?.numberOfLines = 4
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            v.textLabel!.text = Array(Documentation.allCPU.values)[indexPath.row]
            v.detailTextLabel!.text = ""
        case 1:
            v.textLabel!.text = OneByteExamples.allValues[indexPath.row].rawValue
            v.detailTextLabel!.text = OneByteDescriptions.allValues[indexPath.row].rawValue
        case 2:
            v.textLabel!.text = TwoByteExamples.allValues[indexPath.row].rawValue
            v.detailTextLabel!.text = TwoByteDescriptions.allValues[indexPath.row].rawValue
        case 3:
            v.textLabel!.text = OneByteProblems.allValues[indexPath.row].rawValue
            v.detailTextLabel!.text = OneByteProblemDescriptions.allValues[indexPath.row].rawValue
        case 4:
            v.textLabel!.text = TwoByteProblems.allValues[indexPath.row].rawValue
            v.detailTextLabel!.text = TwoByteProblemDescriptions.allValues[indexPath.row].rawValue
        default:
            v.textLabel?.text = "Error"
        }
        
        v.selectionStyle = .blue
        
        return v
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            helpDetail.loadDocumentation(Array(Documentation.allCPU.keys)[indexPath.row])
        case 1:
            helpDetail.loadExample(OneByteExamples.allValues[indexPath.row].rawValue)
        case 2:
            helpDetail.loadExample(TwoByteExamples.allValues[indexPath.row].rawValue)
        case 3:
            helpDetail.loadExample(OneByteProblems.allValues[indexPath.row].rawValue)
        case 4:
           helpDetail.loadExample(TwoByteProblems.allValues[indexPath.row].rawValue)
        default:
            print("Error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Array(Documentation.allCPU.values).count
        case 1:
            return OneByteExamples.allValues.count
        case 2:
            return TwoByteExamples.allValues.count
        case 3:
            return OneByteProblems.allValues.count
        case 4:
            return TwoByteProblems.allValues.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Documentation"
        case 1:
            return "One Byte Examples"
        case 2:
            return "Two Byte Examples"
        case 3:
            return "One Byte Problems"
        case 4:
            return "Two Byte Problems"
        default:
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
