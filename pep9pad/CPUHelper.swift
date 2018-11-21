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
        let url = Bundle.main.url(forResource: doc.rawValue, withExtension:"html")
        let request = URLRequest(url: url!)
        documentationVC.doc.loadRequest(request)
        
        exampleVC.topTextView.setEditable(false)
        exampleVC.bottomTextView.setEditable(false)
    }
    
    func loadExample(_ named: String) -> String {
        exampleVC.setNumTextViews(to: 1)
        exampleVC.bottomTextView.removeAllText()
        switch named {
        case "Figure 12.05":
            exampleVC.loadExample("fig1205", field: .Top, ofType: .pepcpu)
        case "Figure 12.07":
            exampleVC.loadExample("fig1207", field: .Top, ofType: .pepcpu)
        case "Figure 12.09":
            exampleVC.loadExample("fig1209", field: .Top, ofType: .pepcpu)
        case "Figure 12.10":
            exampleVC.loadExample("fig1210", field: .Top, ofType: .pepcpu)
        case "Figure 12.11":
            exampleVC.loadExample("fig1211", field: .Top, ofType: .pepcpu)
        case "Figure 12.12":
            exampleVC.loadExample("fig1212", field: .Top, ofType: .pepcpu)
        case "Figure 12.14":
            exampleVC.loadExample("fig1214", field: .Top, ofType: .pepcpu)
        case "Figure 12.20":
            exampleVC.loadExample("fig1220", field: .Top, ofType: .pepcpu)
        case "Figure 12.21":
            exampleVC.loadExample("fig1221", field: .Top, ofType: .pepcpu)
        case "Figure 12.23":
            exampleVC.loadExample("fig1223", field: .Top, ofType: .pepcpu)
        //Problems
        case "Problem 12.28":
            exampleVC.loadExample("prob1228", field: .Top, ofType: .pepcpu)
        case "Problem 12.29a":
            exampleVC.loadExample("prob1229a", field: .Top, ofType: .pepcpu)
        case "Problem 12.29b":
            exampleVC.loadExample("prob1229b", field: .Top, ofType: .pepcpu)
        case "Problem 12.29c":
            exampleVC.loadExample("prob1229c", field: .Top, ofType: .pepcpu)
        case "Problem 12.29d":
            exampleVC.loadExample("prob1229d", field: .Top, ofType: .pepcpu)
        case "Problem 12.29e":
            exampleVC.loadExample("prob1229e", field: .Top, ofType: .pepcpu)
        case "Problem 12.29f":
            exampleVC.loadExample("prob1229f", field: .Top, ofType: .pepcpu)
        case "Problem 12.29g":
            exampleVC.loadExample("prob1229g", field: .Top, ofType: .pepcpu)
        case "Problem 12.30":
            exampleVC.loadExample("prob1230", field: .Top, ofType: .pepcpu)
        case "Problem 12.31a":
            exampleVC.loadExample("prob1231a", field: .Top, ofType: .pepcpu)
        case "Problem 12.31b":
            exampleVC.loadExample("prob1231b", field: .Top, ofType: .pepcpu)
        case "Problem 12.31c":
            exampleVC.loadExample("prob1231c", field: .Top, ofType: .pepcpu)
        case "Problem 12.31d":
            exampleVC.loadExample("prob1231d", field: .Top, ofType: .pepcpu)
        case "Problem 12.31e":
            exampleVC.loadExample("prob1231e", field: .Top, ofType: .pepcpu)
        case "Problem 12.31f":
            exampleVC.loadExample("prob1231f", field: .Top, ofType: .pepcpu)
        case "Problem 12.31g":
            exampleVC.loadExample("prob1231g", field: .Top, ofType: .pepcpu)
        case "Problem 12.32a":
            exampleVC.loadExample("prob1232a", field: .Top, ofType: .pepcpu)
        case "Problem 12.32b":
            exampleVC.loadExample("prob1232b", field: .Top, ofType: .pepcpu)
        case "Problem 12.32c":
            exampleVC.loadExample("prob1232c", field: .Top, ofType: .pepcpu)
        case "Problem 12.32d":
            exampleVC.loadExample("prob1232d", field: .Top, ofType: .pepcpu)
        case "Problem 12.32e":
            exampleVC.loadExample("prob1232e", field: .Top, ofType: .pepcpu)
        case "Problem 12.32f":
            exampleVC.loadExample("prob1232f", field: .Top, ofType: .pepcpu)
        case "Problem 12.32g":
            exampleVC.loadExample("prob1232g", field: .Top, ofType: .pepcpu)
        case "Problem 12.32h":
            exampleVC.loadExample("prob1232h", field: .Top, ofType: .pepcpu)
        case "Problem 12.32i":
            exampleVC.loadExample("prob1232i", field: .Top, ofType: .pepcpu)
        case "Problem 12.32j":
            exampleVC.loadExample("prob1232j", field: .Top, ofType: .pepcpu)
        case "Problem 12.32k":
            exampleVC.loadExample("prob1232k", field: .Top, ofType: .pepcpu)
        case "Problem 12.32l":
            exampleVC.loadExample("prob1232l", field: .Top, ofType: .pepcpu)
        case "Problem 12.33a":
            exampleVC.loadExample("prob1233a", field: .Top, ofType: .pepcpu)
        case "Problem 12.33b":
            exampleVC.loadExample("prob1233b", field: .Top, ofType: .pepcpu)
        case "Problem 12.33c":
            exampleVC.loadExample("prob1233c", field: .Top, ofType: .pepcpu)
        case "Problem 12.33d":
            exampleVC.loadExample("prob1233d", field: .Top, ofType: .pepcpu)
        case "Problem 12.33e":
            exampleVC.loadExample("prob1233e", field: .Top, ofType: .pepcpu)
        case "Problem 12.33f":
            exampleVC.loadExample("prob1233f", field: .Top, ofType: .pepcpu)
        case "Problem 12.34a":
            exampleVC.loadExample("prob1234a", field: .Top, ofType: .pepcpu)
        case "Problem 12.34b":
            exampleVC.loadExample("prob1234b", field: .Top, ofType: .pepcpu)
        case "Problem 12.35a":
            exampleVC.loadExample("prob1235a", field: .Top, ofType: .pepcpu)
        case "Problem 12.35b":
            exampleVC.loadExample("prob1235b", field: .Top, ofType: .pepcpu)
        case "Problem 12.35c":
            exampleVC.loadExample("prob1235c", field: .Top, ofType: .pepcpu)
        case "Problem 12.35d":
            exampleVC.loadExample("prob1235d", field: .Top, ofType: .pepcpu)
        case "Problem 12.35e":
            exampleVC.loadExample("prob1235e", field: .Top, ofType: .pepcpu)
        case "Problem 12.35f":
            exampleVC.loadExample("prob1235f", field: .Top, ofType: .pepcpu)
        case "Problem 12.35g":
            exampleVC.loadExample("prob1235g", field: .Top, ofType: .pepcpu)
        case "Problem 12.35h":
            exampleVC.loadExample("prob1235h", field: .Top, ofType: .pepcpu)
        case "Problem 12.35i":
            exampleVC.loadExample("prob1235i", field: .Top, ofType: .pepcpu)
        case "Problem 12.35j":
            exampleVC.loadExample("prob1235j", field: .Top, ofType: .pepcpu)
        case "Problem 12.35k":
            exampleVC.loadExample("prob1235k", field: .Top, ofType: .pepcpu)
        case "Problem 12.35l":
            exampleVC.loadExample("prob1235l", field: .Top, ofType: .pepcpu)
        case "Problem 12.36a":
            exampleVC.loadExample("prob1236a", field: .Top, ofType: .pepcpu)
        case "Problem 12.36b":
            exampleVC.loadExample("prob1236b", field: .Top, ofType: .pepcpu)
        case "Problem 12.36c":
            exampleVC.loadExample("prob1236c", field: .Top, ofType: .pepcpu)
        case "Problem 12.36d":
            exampleVC.loadExample("prob123d", field: .Top, ofType: .pepcpu)
        case "Problem 12.36e":
            exampleVC.loadExample("prob1236e", field: .Top, ofType: .pepcpu)
        case "Problem 12.36f":
            exampleVC.loadExample("prob123f", field: .Top, ofType: .pepcpu)
        default:
            exampleVC.topTextView.removeAllText()
        }
        
        return "Copy To Microcode"
    }
    
    func loadExampleToProj(_ text: String!, ofType: PepFileType!, io: String!, usesTerminal: Bool!) {
        cpuMasterVC.loadExample(text: text)
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
