//
//  TraceController.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class TraceController: UIViewController {
    
    
    var traceTable: TraceViewController!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "embedTraceTable":
                traceTable = segue.destination as! TraceViewController
                
            default:
                break

            }
        }
    }

}

