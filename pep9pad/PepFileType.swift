//
//  PepFileType.swift
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

enum PepFileType: String {
    case pep    = "pep"
    case pepo   = "pepo"
    case pepl   = "pepl"
    case pepb   = "pepb"
    case peph   = "peph"
    case pepcpu = "pepcpu"
    case c      = "txt" // things get buggy if we use dynamically load .c files, but not if we load .txt
}
