//
//  ViewController.swift
//
//  Copyright (c) 2015 Jiajia Luo. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginWithTwitterTapped(sender: AnyObject) {
        PFTwitterUtils.initializeWithConsumerKey("a1S2iZkEBov2YQ27e9pPpVXM2", consumerSecret: "iMAsIAToivWf1JWJYvnlm9hKCSSR7wS48DFt9JftrD09QMK1ZP")
        
        PFTwitterUtils.logInWithBlock { (user: PFUser?, error: NSError?) -> Void in
            if user == nil {
                println(error)
            } else {
                self.performSegueWithIdentifier("moveToSoundzSegue", sender: self)
                
            }
        }
    }
    
}

