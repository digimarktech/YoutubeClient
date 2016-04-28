//
//  BackTableVC.swift
//  Pretty Simply Music App
//
//  Created by Marc Aupont on 4/27/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import Foundation


class BackTableVC: UITableViewController, VideoModelDelegate {
    
    let model:VideoModel = VideoModel()
    
    var menuItems = [String]()

    var tableArray = [String]()
    
    
    override func viewDidLoad() {
        
        model.delegate = self
        
    }
    
    func videoModelDidUpate() {
        
        self.menuItems = model.menuTitles
        
        self.tableView.reloadData()
    }
    
    func dataReady() {
        
        
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.menuTitles.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = model.menuTitles[indexPath.row]
        
        return cell
    }

    

}
