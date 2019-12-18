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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menuPulse.layer.add(setupPulse(), forKey: "animateOpacity")
        menuPulse.layer.add(setupScale(), forKey: "animateScale")
        cpuPulse.layer.add(setupPulse(), forKey: "animateOpacity")
        cpuPulse.layer.add(setupScale(), forKey: "animateScale")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pressed = segue.identifier == "pep9Segue" ? menuButton: cpuButton
        let secondVC = segue.destination as! SecondViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
        secondVC.mode = pressed == menuButton ? "PEP" : "CPU"
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
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        return pulseAnimation
    }
    
    func setupScale() -> CABasicAnimation{
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 1.1
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        return pulseAnimation
    }

   /*
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation        animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for     clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 5.0;
    
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    //CGPoint endPoint = CGPointMake(310, 450);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, 10, 10);
    
    //change the rectangle to adjust diameter and position
    CGRect rectangle = CGRectMake(50,250,220,150);
    
    CGPathAddEllipseInRect(curvedPath, NULL, rectangle);
    
    
    
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    
    
    [myObject.layer addAnimation:pathAnimation forKey:@"moveTheObject"];
*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

