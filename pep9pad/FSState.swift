//
//  FSState.swift
//  pep9pad
//
//  Created by Stan Warford on 10/19/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

/// All possible states of the ASM FileSystem.  For the FSM, see the `Documentation` folder.
enum FSState {
case Blank
case UnsavedUnnamed
case UnsavedNamed
case SavedNamed
}
