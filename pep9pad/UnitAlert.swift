//
//  unitAlert.swift
//  pep9pad
//
//  Created by David Nicholas on 1/22/19.
//  Copyright © 2019 Pepperdine University. All rights reserved.
//

import Foundation
import UIKit

class UnitAlert: NSObject {
    
    let alertView = UIView()
    let msgLabel = UILabel()
    let dismissBtn = UIButton()
    
    var masterVC : CPUViewController!
    
    let tag : Int = 100
    
    override init(){
        super.init()
    }
    
    
    func startTimer(){
        let _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }
    
    func showAlert(masterVC : CPUViewController, bgColor : UIColor, msg : String){
        self.masterVC = masterVC
        
        if let scrollView = masterVC.CPUScrollView {
            
            
            let height : CGFloat = 50
            let y = masterVC.view.frame.height - height
            let x = masterVC.view.frame.width - scrollView.frame.width
            let width = scrollView.frame.width
            let bufferVal : CGFloat = 20
            
            alertView.backgroundColor = bgColor
            alertView.tag = tag
            alertView.alpha = 0
            //alertView.frame = CGRect(x: x, y: y - bufferVal, width: 0, height: height)
            alertView.frame = CGRect(x: x, y: y, width: width, height: height)
            
            msgLabel.frame = CGRect(x: bufferVal, y: 0, width: width - 200, height: height)
            msgLabel.textAlignment = .left
            msgLabel.text = msg
            alertView.addSubview(msgLabel)
            
            
             masterVC.view.addSubview(alertView)
            
           UIView.animate(withDuration: 0.5, animations: {
                self.alertView.alpha = 1
                //self.alertView.frame = CGRect(x: x, y: y - bufferVal, width: width, height: height)
           })
            
            startTimer()
            
        }
    }
    
  
    
        @objc func dismissAlert(){
            print("HI")
            if masterVC != nil {
                UIView.animate(withDuration: 0.75, animations: {
                     self.alertView.alpha = 0
                }, completion: { _ in
                    if let viewWithTag = self.masterVC.view.viewWithTag(self.tag){
                        viewWithTag.removeFromSuperview()
                    }
                })

            }
    }

    

}
