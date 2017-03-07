//
//  StackController.swift
//  pep9pad
//
//  Created by Josh Haug on 12/18/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit


class StackController: UIViewController, UIScrollViewDelegate {
    
    var stackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iew.addSubview(MemoryCellGraphicsItem())
        stackView = UIView(frame: scrollView.frame)
        stackView.addSubview(UIImageView(image: UIImage(named: "MemTrace")))
        scrollView.addSubview(stackView)

        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        //scrollView.addSubview(MemoryCellGraphicsItem(frame: CGRect(x:0,y:0,width:40,height:40)))
    }

    // MARK: - Interface Builder
    
    @IBOutlet var scrollView: UIScrollView!{
        didSet {
            scrollView.backgroundColor = .white
            //scrollView.addSubview(MemoryCellGraphicsItem(frame: scrollView.frame))
            //scrollView.addSubview(MemoryCellGraphicsItem())
        }
    }




    // MARK: Attributes
    
    /* NOTE -- See memorytracepane and memorycellgraphicsitem in ../Ref, 
    the logic will be the same but there is quite a bit of Qt complexity 
    that will need to be ported over.  Makes sense to use bezier curves 
    for rendering, particularly because they'll look good no matter the 
    screen res.  Could programmatically generate the bezier curves using 
    an automated tool like PaintCode.  
    */
    


    // MARK: - Methods
    
    // See cellSize(Enu::ESymbolFormat symbolFormat) declaration in Sim.h.  That function is used exclusively in these classes, and should be implemented here in the iOS version. 
    
    /// Post: The memory trace is populated (on assembly).
    func setMemoryTrace() {

    }
    
    /// Post: The memory trace is updated.
    func updateMemoryTrace() {
        
    }
    
    
    /// Post: Modfied bytes are cached for updating the sim view
    func cacheChanges() {
        
    }
    
    /// Post: Stack changes are cached for the next time the simulation view is updated
    func cacheStackChanges() {
        
    }
    
    /// Post: Heap changes are cached for the next time the simulation view is updated
    func cacheHeapChanges() {
        
    }
    
    
    // MARK: - Conformance to UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stackView
    }
    
}
