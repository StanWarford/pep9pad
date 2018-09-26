//
//  OneByteModel.swift
//  pep9pad
//
//  Created by David Nicholas on 9/24/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import Foundation


protocol OneByteModel
{

    static func isCorrectALUInput(ALUFn : Int)//,CpuGraphicsItems *cpuPaneItems) -> Bool
    static func getAMuxOut(out : UInt8, errorString : String)//, CpuGraphicsItems *cpuPaneItems) -> Bool
    static func getMDRMuxOut(out : UInt8, errorString : String)//, CpuGraphicsItems *cpuPaneItems) -> Bool
    
}
