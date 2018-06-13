//
//  UIConstants.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit


/// The height of the navigation bar (the bigger one, that has a title and back arrows and all that).  
/// On all iOS devices, it is 44 points high.
let navBarHeight: CGFloat = 44

var heightOfTabBar: CGFloat = 59


/// The height of the status bar (the smaller one, that has the time and the network strength and whatnot).
/// On all iOS devices, it is 20 points high.
/// In the case of concurrent navigation or a concurrent phone call, it becomes 40 points high.
let statBarHeight: CGFloat = 20

/// Combined height of the navigation and status bars.  Useful when manipulating views programmatically.
/// For reference, the status bar's height is 20 points, and the nav bar's height is 44.
let navAndStatBarHeight: CGFloat = 64

func selectedBlue() -> UIColor {
    return UIColor(red: 6, green: 108, blue: 255, alpha: 1.0)
}


