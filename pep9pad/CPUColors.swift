//
//  CPUColors.swift
//  pep9pad
//
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

// this will contain all the colors used in both the onebyte and twobyte cpus.
//arrow lines
let unactivelinecolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000)
let activelinecolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000)

//pipes and boxes
let unactiveshapecolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000) //unactive boxes, pipes
let ALUcolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000) //ALU color never changes
let activeABbuscolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000) //A bus, B bus active
let activeCbuscolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000) //C bus active, includes Cmux and NZVC0000 arrow
let memwritecolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000) //all pipes headed to mem
let memreadcolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000) //all pipes headed from mem

//registers (includes register bank, MARs, and NVZC
let registerbackgroundcolor = UIColor(red: 0.511, green: 0.583, blue: 0.670, alpha: 1.000)
