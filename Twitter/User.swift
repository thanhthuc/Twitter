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
    var profileURL: URL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        name = dictionary["name"] as? String as NSString?
        screenName = dictionary["screen_name"] as? String as NSString?
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileURL = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String as NSString?
    }
    
    class func userWithArray(_ dictionaries: [NSDictionary]) -> [User]{
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
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: keyCurrentUser) as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options:[])
                defaults.set(data, forKey: keyCurrentUser)
            }
            else {
                defaults.set(nil, forKey: keyCurrentUser)
            }
            
            defaults.synchronize()
        }
        
        
    }
}
