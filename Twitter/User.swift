//
//  User.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit

let keyCurrentUser = "currentUserData"

class User: NSObject {
    var name: NSString?
    var screenName: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileURL = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    class func userWithArray(dictionaries: [NSDictionary]) -> [User]{
        var users: [User] = []
        for dictionary in dictionaries {
            let user = User(dictionary: dictionary)
            users.append(user)
        }
        return users
    }
    
    static var userDidLogout = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey(keyCurrentUser) as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options:[])
                defaults.setObject(data, forKey: keyCurrentUser)
            }
            else {
                defaults.setObject(nil, forKey: keyCurrentUser)
            }
            
            defaults.synchronize()
        }
        
        
    }
}
