//
//  TweetViewController.swift
//  Twitter
//
//  Created by admin on 7/31/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit
import AFNetworking

class TweetViewController: UITableViewController {
    
    
    var tweet: Tweet?
    
    @IBOutlet weak var profileURL: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameScreenLabel: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        // Do any additional setup after loading the view.
        if tweet != nil {
            let url = tweet?.profileImageUrlUserTweet
            profileURL.setImageWith(url! as URL)
            nameLabel.text = tweet?.nameUserTweet as? String
            nameScreenLabel.text = "@" + (tweet?.screenNameUserTweet as? String)!
            text.text = tweet?.text as? String
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let stringDate = dateFormat.string(from: tweet!.timestamp! as Date)
            dateLabel.text = stringDate
            
            retweetCount.text = String(describing: tweet?.retweetCount)
            favouriteCount.text = String(describing: tweet?.favouritesCount)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyAction(_ sender: AnyObject) {
        
    }

    @IBAction func reTweetAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func favouriteAction(_ sender: AnyObject) {
        
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
