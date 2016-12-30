//
//  TwitterClient.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let consumerKey = "uBw8qAHslm8HW6s7iJEvlvWfW"
let consumerSecretKey = "OTHn4qEchvXgg8SlBYKjArYr2lkwIVaVxenJfbzdZ4uNIsSNPs"
let baseURL = "https://api.twitter.com/"
let requestToken = "oauth/request_token"
let linkAccessToken = "oauth/access_token"
let authorizeURL = "https://api.twitter.com/oauth/authorize?oauth_token"

class TwitterClient: BDBOAuth1SessionManager {
    static let shareInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com/"), consumerKey: consumerKey, consumerSecret: consumerSecretKey)
    
    //get string home time line
    func homeTimeLine(_ success: @escaping ([Tweet]) -> (), failure: (NSError) -> ()) {
        let urlStringHomeTimeLineToGet = "1.1/statuses/home_timeline.json"
        
      
        get(urlStringHomeTimeLineToGet, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, respond:Any?) in
            
            let dictionaries = respond as? [NSDictionary]
            var tweets: [Tweet] = []
            if dictionaries?.count > 0 {
                tweets = Tweet.tweetsWithArray(dictionaries!)
            }
            
            success(tweets)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            
        }
        
        
    }
    
    func currentAccount(_ success: @escaping (User) -> (), failure: (NSError) -> ()) {
        
        //get current user from twitter API
        let urlStringToGet = "1.1/account/verify_credentials.json"
        get(urlStringToGet, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, respond: Any?) in
            
            let userDictionary = respond as! NSDictionary
            
            let users = User(dictionary: userDictionary)
            
            success(users)
            
        }) { (task:URLSessionDataTask?, error: Error) in
            
        }
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    func login(_ success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shareInstance?.deauthorize()
        
        TwitterClient.shareInstance?.fetchRequestToken(withPath: requestToken, method: "POST", callbackURL: URL(string: "mytwitter://oauth"), scope: nil, success: { (respond: BDBOAuth1Credential?) in
            
            //open browser to authorize, login
            print("i got the request token: \(respond?.token)")
            UIApplication.shared.openURL(URL(string:"\(authorizeURL)=\((respond?.token)!)")!)
            
            
        }, failure: { (error: Error?) in
            self.loginFailure!(error as! NSError)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: User.userDidLogout), object: nil)
    }
    
    func handleOpenUrl(_ url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: linkAccessToken, method: "POST", requestToken: requestToken, success: { (respond:BDBOAuth1Credential?) in
            
            self.currentAccount({ (user) in
                User.currentUser = user
                
                self.loginSuccess?()
    
                }, failure: { (error) in
                    self.loginFailure?(error)
            })

        }) { (error:Error?) in
            
            self.loginFailure?(error as! NSError)
        }
    }
    
}
