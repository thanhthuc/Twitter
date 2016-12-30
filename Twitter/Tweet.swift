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
    var profileImageUrlUserTweet: URL?
    var text: NSString?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        if let userMentionDict = dictionary["user_mentions"] {
            let userMentionDict = userMentionDict as! NSDictionary
            userMention = userMentionDict["name"] as? NSString
        }
        
        let nameUserTweetDict = dictionary["user"] as! NSDictionary
        nameUserTweet = nameUserTweetDict["name"] as? NSString
        
        
        
        let screenNameUserTweetDict = dictionary["user"] as! NSDictionary
        screenNameUserTweet = screenNameUserTweetDict["screen_name"] as? NSString
        
        let profileUrlDict = dictionary["user"] as! NSDictionary
        let profileUrl = profileUrlDict["profile_image_url"] as? NSString
        if let profileUrl = profileUrl {
            profileImageUrlUserTweet = URL(string: profileUrl as String)
        }
        
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStamString = dictionary["created_at"] as? String
        
        if let timeStamString = timeStamString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStamString)
        }
    }

    class func tweetsWithArray(_ dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
