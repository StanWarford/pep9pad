//
//  CPUViewController.swift
//  pep9pad
//
//  Created by David Nicholas on 9/11/18.
//  Copyright © 2018 Pepperdine University. All rights reserved.
//

import UIKit

class CPUViewController: UIViewController {

    let drawingSize = CGRect(x: 0.0, y: 0.0, width: 840, height: 1024)
    
    lazy var currentCPUDisplay = CPU1ByteView(frame: drawingSize)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCPU()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var CPUScrollView: UIScrollView!
    
    func setupCPU(){
        CPUScrollView.contentSize = CGSize(width: 840, height: 1024)
        CPUScrollView.addSubview(currentCPUDisplay)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
