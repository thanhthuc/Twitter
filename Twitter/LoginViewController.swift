//
//  LoginViewController.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


@IBDesignable

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: LoginButton!
   
    @IBOutlet weak var iconTwitter: UIImageView!
    @IBOutlet weak var distanceToLogin: NSLayoutConstraint!
    var distanceConstraint: CGFloat = 0
    var originalDistanceConstraint: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
        iconTwitter.isUserInteractionEnabled = true
        iconTwitter.addGestureRecognizer(panGesture)
        originalDistanceConstraint = distanceToLogin.constant
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(_ sender: UIButton) {
        
        
    }
    
    func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translateInView = sender.translation(in: view)

        if sender.state == .began {
            distanceConstraint = distanceToLogin.constant
            
        } else if sender.state == .changed {
            distanceToLogin.constant = distanceConstraint - translateInView.y
            view.layoutIfNeeded()
            
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5, options: .beginFromCurrentState, animations: {
                
                if self.distanceToLogin.constant < 100 {
                    self.distanceToLogin.constant = 0
                    
                } else {
                    self.distanceToLogin.constant = self.originalDistanceConstraint
                }
                self.view.layoutIfNeeded()
                
            }, completion: { (finish) in
                
            })
        }
        
        if distanceToLogin.constant == 0 {
            let client = TwitterClient.shareInstance
            
            client?.login({
                
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                print("i 've got login")
                
            }) { (error:NSError) in
                print(error.localizedDescription)
            }
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
