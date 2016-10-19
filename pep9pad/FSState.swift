//
//  FSState.swift
//  pep9pad
//
//  Created by Stan Warford on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation
enum FSState {
case Blank
case UnsavedUnnamed
case UnsavedNamed
case SavedNamed
}

var fsState: FSState = .SavedNamed
