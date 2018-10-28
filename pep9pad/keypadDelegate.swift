//
//  keypadDelegate.swift
//  pep9pad
//
//  Created by David Nicholas on 10/28/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation
import UIKit

protocol keypadDelegate{
    func keyPressed(value : String, label : UILabel)
    func hideKeyboard()
    func backspacePressed(label : UILabel)
    
    var currentIndex : IndexPath {get set}
}
