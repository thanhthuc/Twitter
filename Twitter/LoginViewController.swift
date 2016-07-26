//
//  LoginViewController.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import BDBOAuth1Manager




class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(sender: UIButton) {
        
        let client = TwitterClient.shareInstance
        
        client.login({ 
            
            self.performSegueWithIdentifier("loginSegue", sender: self)
            print("i 've got login")
            
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
