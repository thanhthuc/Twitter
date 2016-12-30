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
            avatarImage.setImageWith(urlString! as URL)
            
            nameLabel.text = tweet.nameUserTweet as? String
            nickNameLabel.text = "@" + (tweet.screenNameUserTweet as? String)!
            tweetLabel.text = tweet.text as? String
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "HH:mm"
            let stringDate = dateFormat.string(from: tweet.timestamp! as Date)
            timeLabel.text = stringDate
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImage.layer.masksToBounds = true
        self.avatarImage.layer.cornerRadius = self.avatarImage.bounds.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
