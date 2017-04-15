//
//  ViewController.swift
//  TestTransition
//
//  Created by Joseph Ramli on 3/23/17.
//  Copyright © 2017 Joseph Ramli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var menuPulse: UIButton!
    
    @IBOutlet weak var cpuButton: UIButton!
 
    @IBOutlet weak var cpuPulse: UIButton!
    
    var pressed: UIButton!
    
    let transition = CircularTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.layer.cornerRadius = menuButton.frame.size.width / 2
        menuPulse.layer.cornerRadius = menuButton.frame.size.width / 2
        cpuButton.layer.cornerRadius = cpuButton.frame.size.width / 2
        cpuPulse.layer.cornerRadius = cpuButton.frame.size.width / 2
        menuPulse.layer.add(setupPulse(), forKey: "animateOpacity")
        menuPulse.layer.add(setupScale(), forKey: "animateScale")
        cpuPulse.layer.add(setupPulse(), forKey: "animateOpacity")
        cpuPulse.layer.add(setupScale(), forKey: "animateScale")
        //menuButton.layer.add(setupScaleY(), forKey: "animateScale")

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pressed = segue.identifier == "mainSegue" ? menuButton: cpuButton
        let secondVC = segue.destination as! SecondViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = pressed.center
        transition.circleColor = pressed.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = pressed.center
        transition.circleColor = pressed.backgroundColor!
        
        return transition
    }
    
    func setupPulse() -> CABasicAnimation{
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 0.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        return pulseAnimation
    }
    
    func setupScale() -> CABasicAnimation{
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 1.1
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        return pulseAnimation
    }

    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
