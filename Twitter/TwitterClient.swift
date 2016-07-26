//
//  TwitterClient.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let consumerKey = "VvYUAz3UiPX86JIWqwwGokfgL"
let consumerSecretKey = "UlKylYQDIAi322PR9cpzV00iBLReOwRynRomyhoUHLRYxYPa21"
let baseURL = "https://api.twitter.com/"
let requestToken = "oauth/request_token"
let accessToken = "oauth/access_token"
let authorizeURL = "https://api.twitter.com/oauth/authorize?oauth_token"

class TwitterClient: BDBOAuth1SessionManager {
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/"), consumerKey: consumerKey, consumerSecret: consumerSecretKey)
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let urlStringHomeTimeLineToGet = "1.1/statuses/home_timeline.json"
        GET(urlStringHomeTimeLineToGet, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, respond:AnyObject?) in
            
            let dictionaries = respond as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                
        })
    }
    
    func currentAccount() {
        let urlStringToGet = "1.1/account/verify_credentials.json"
        GET(urlStringToGet, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, respond) in
            
            let userDictionary = respond as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            print("name: \(user.name)")
            print("profile: \(user.profileURL)")
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                print(error.localizedDescription)
        })
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shareInstance.deauthorize()
        
        TwitterClient.shareInstance.fetchRequestTokenWithPath(requestToken, method: "POST", callbackURL: NSURL(string: "mytwitter://oauth"), scope: nil, success: { (respond: BDBOAuth1Credential!) in
            
            print("i got the request token: \(respond.token)")
            
            UIApplication.sharedApplication().openURL(NSURL(string:"\(authorizeURL)=\(respond.token)")!)
            
        }) { (error: NSError!) in
            self.loginFailure!(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath(accessToken, method: "POST", requestToken: requestToken, success: { (respond:BDBOAuth1Credential!) in
            
            self.loginSuccess?()
            
        }) { (error:NSError!) in
            
            self.loginFailure?(error)
        }

    }
    
}
