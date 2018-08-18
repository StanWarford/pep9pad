//
//  SecondViewController.swift
//  TestTransition
//
//  Created by Joseph Ramli on 3/23/17.
//  Copyright © 2017 Joseph Ramli. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newproject: UIButton!
    @IBAction func newprojectbuttonpressed(_ sender: Any) {
        makePep9Main()
    }
    @IBAction func newCPUprojectbuttonpressed(_ sender: Any) {
        makeCPU()
    }
    
    @IBOutlet weak var tableOfProjects: UITableView! {
        didSet {
            self.tableOfProjects.dataSource = self
            self.tableOfProjects.delegate = self
        }
    }
    
    func makePep9Main() {
        let storyb = UIStoryboard(name: "Pep9Main", bundle: Bundle.main)
        let vc = storyb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
    func makeCPU() {
        let storyb = UIStoryboard(name: "CPU", bundle: Bundle.main)
        let vc = storyb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
    var recents: [String] = []
    
    override func viewDidLoad() {
        recents = projectModel.recentProjectNames()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        projectModel.loadExistingProject(named: recents[indexPath.row])
        newprojectbuttonpressed(newproject)
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
