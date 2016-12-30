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
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        configTableview()
        
        TwitterClient.shareInstance?.homeTimeLine({ (tweets:[Tweet]) in
            
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
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.shareInstance?.homeTimeLine({ (tweets:[Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
    }
    
    func setUpProgress() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
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
    
    @IBAction func onLogout(_ sender: AnyObject) {
        
        TwitterClient.shareInstance?.logout()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = tableView.indexPath(for: sender as! HomeLineTableViewCell)
        let vc = segue.destination as! TweetViewController
        if tweets.count > 0 {
            vc.tweet = self.tweets[indexPath!.row]
        }
    }
 
    //infinite scroll
    var isMoreDataloading = false
    var loadingMoreView:InfiniteScrollActivityView?
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tweets.count > 0 {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! HomeLineTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isMoreDataloading == false {

            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //load data if 
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                
                isMoreDataloading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                self.reloadMoreData()
            }
        }
    }
    
    func reloadMoreData() {
        TwitterClient.shareInstance?.homeTimeLine({ (tweets:[Tweet]) in
            
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








