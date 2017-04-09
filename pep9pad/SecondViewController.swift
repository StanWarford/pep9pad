//
//  SecondViewController.swift
//  TestTransition
//
//  Created by Joseph Ramli on 3/23/17.
//  Copyright © 2017 Joseph Ramli. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func newprojectbuttonpressed(_ sender: Any) {
        print("Jo was here")
    }
    @IBOutlet weak var tableOfProjects: UITableView! {
        didSet {
            self.tableOfProjects.dataSource = self
            self.tableOfProjects.delegate = self
        }
    }
    
    var recents: [String] = []
    
    override func viewDidLoad() {
        recents = projectModel.recentProjectNames()
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
    }
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        projectModel.loadExistingProject(named: recents[indexPath.row])
        newprojectbuttonpressed(dismissButton)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        c.textLabel?.text = recents[indexPath.row]
        c.textLabel?.textColor = UIColor.white
        c.backgroundColor = UIColor.clear
        return c
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    
    
    
    
}
