//
//  ListSoundzViewController.swift
//  ParseStarterProject
//
//  Created by Jiajia Luo on 5/23/15.
//  Copyright (c) 2015 Jiajia Luo. All rights reserved.
//
//  Add to GitHub

import UIKit
import Parse

class ListSoundzViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sounds : [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Roll Tide...
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        var soundsQuery = PFQuery(className: "Sound")
        soundsQuery.whereKeyExists("Audio")
        soundsQuery.includeKey("User")
        
        soundsQuery.findObjectsInBackgroundWithBlock { (sounds:[AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.sounds = sounds as! [PFObject]
                self.tableView.reloadData()
            } else {
                println("Houston...we have a problem")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var sound = self.sounds[indexPath.row]
        
        var user = sound["User"] as! PFUser
        
        var cell = UITableViewCell()
        
        cell.textLabel!.text = user["username"] as? String
        
        return cell
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}


































