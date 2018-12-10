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
    
    @IBOutlet weak var dismissButton: UIButton!

    @IBAction func newprojectbuttonpressed(_ sender: Any) {
        makePep9Main()
    }
    @IBAction func newCPUprojectbuttonpressed(_ sender: Any) {
        makeCPU()
    }
    
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableOfProjects: UITableView! {
        didSet {
            self.tableOfProjects.dataSource = self
            self.tableOfProjects.delegate = self
        }
    }
    
    
    // set to either "PEP" or "CPU"
    var mode: String? = nil
    
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
        // load the recent projects, either from Pep9 or CPU project model
        if mode == "PEP" {
            recents = projectModel.recentProjectNames()
        } else {
            recents = cpuProjectModel.recentProjectNames()
        }
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        super.viewDidLoad()
    }
    
    
    /// Overriding the viewDidAppear, so that these are reloaded when the view is loading.
    override func viewDidAppear(_ animated: Bool) {
        // load the recent projects, either from Pep9 or CPU project model
        if mode == "PEP" {
            recents = projectModel.recentProjectNames()
        } else {
            recents = cpuProjectModel.recentProjectNames()
        }
        //dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        tableOfProjects.reloadData()
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == "PEP" {
            projectModel.loadExistingProject(named: recents[indexPath.row])
            newprojectbuttonpressed(newproject)
        } else {
            cpuProjectModel.loadExistingProject(named: recents[indexPath.row])
            newCPUprojectbuttonpressed(newproject)
        }
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
