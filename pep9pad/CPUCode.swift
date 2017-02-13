//
//  CPUCode.swift
//  pep9pad
//
//  Created by Josh Haug on 2/13/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import Foundation

class CPUCode {
    func isMicrocode() -> Bool { return false }
    func setCpuLabels(items: inout CpuGraphicsItems) {}
    func getObjectCode() -> String { return "" }
    func getSourceCode() -> String { return "" }
    func hasUnitPre() -> Bool { return false }
    func setUnitPre(mem: inout MainMemory, cpu: inout CPUPane) {}
    func testPostCondition(mem: inout MainMemory, )
}
