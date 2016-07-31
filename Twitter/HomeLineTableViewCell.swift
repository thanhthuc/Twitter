//
//  HomeLineTableViewCell.swift
//  Twitter
//
//  Created by admin on 7/31/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import AFNetworking

class HomeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var personTweetToMeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            
            personTweetToMeLabel.text = tweet.userMention as? String
            let urlString = tweet.profileImageUrlUserTweet
            avatarImage.setImageWithURL(urlString!)
            
            nameLabel.text = tweet.nameUserTweet as? String
            nickNameLabel.text = "@" + (tweet.screenNameUserTweet as? String)!
            tweetLabel.text = tweet.text as? String
            
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "HH:mm"
            let stringDate = dateFormat.stringFromDate(tweet.timestamp!)
            timeLabel.text = stringDate
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImage.layer.masksToBounds = true
        self.avatarImage.layer.cornerRadius = self.avatarImage.bounds.size.height/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
