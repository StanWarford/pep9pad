//
//  HelpDetailViewController.swift
//  pep9pad
//
//  Created by Josh Haug on 3/8/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit

class HelpDetailViewController: UIViewController {

    internal var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.width-320, view.bounds.height)
        webView = UIWebView(frame: rect)
        view.addSubview(webView)
        loadDocumentation(.AssemblyLanguage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDocumentation(doc: Documentation) {
        let url = NSBundle.mainBundle().URLForResource(doc.rawValue, withExtension:"html")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
}
