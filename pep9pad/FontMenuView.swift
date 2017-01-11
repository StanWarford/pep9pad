//
//  FontMenuView.swift
//  pep9pad
//
//  Created by Josh Haug on 1/9/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import UIKit

class FontMenuView: UIView {
    
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        // below doesn't work as returned class name is normally in project module scope
        /*let viewName = NSStringFromClass(self.classForCoder)*/
        let view: UIView = Bundle.main.loadNibNamed("FontMenu", owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }

    
    
    
    
    @IBOutlet weak var fontSizeStepper: UIStepper!
    
    @IBAction func fontSizeStepperChanged(_ sender: UIStepper) {
    }
    
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
    }
    
    
    
    
}
