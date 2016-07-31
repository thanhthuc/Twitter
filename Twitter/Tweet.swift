//
//  Tweet.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var userMention: NSString?
    var nameUserTweet: NSString?
    var screenNameUserTweet: NSString?
    var profileImageUrlUserTweet: NSURL?
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        if let userMentionDict = dictionary["user_mentions"] {
            userMention = userMentionDict["name"] as? String
        }
        
        nameUserTweet = dictionary["user"]!["name"] as? String
        screenNameUserTweet = dictionary["user"]!["screen_name"] as? String
        
        let profileUrl = dictionary["user"]!["profile_image_url"] as? String
        if let profileUrl = profileUrl {
            profileImageUrlUserTweet = NSURL(string: profileUrl)
        }
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStamString = dictionary["created_at"] as? String
        
        if let timeStamString = timeStamString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timeStamString)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
