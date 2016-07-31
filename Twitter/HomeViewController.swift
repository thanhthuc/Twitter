//
//  TweetViewController.swift
//  Twitter
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    var users: [User] = []
    
    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        configTableview()
        
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
        
        //infinite scroll
        setUpProgress()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
    }
    
    func setUpProgress() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    func configTableview() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
        TwitterClient.shareInstance.logout()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = tableView.indexPathForCell(sender as! HomeLineTableViewCell)
        let vc = segue.destinationViewController as! TweetViewController
        if tweets.count > 0 {
            vc.tweet = self.tweets[indexPath!.row]
        }
    }
 
    //infinite scroll
    var isMoreDataloading = false
    var loadingMoreView:InfiniteScrollActivityView?
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tweets.count > 0 {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! HomeLineTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if isMoreDataloading == false {

            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //load data if 
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging {
                
                isMoreDataloading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                self.reloadMoreData()
            }
        }
    }
    
    func reloadMoreData() {
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) in
            
            self.tweets = tweets
            
            self.isMoreDataloading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            self.tableView.reloadData()
            
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
    }
}








