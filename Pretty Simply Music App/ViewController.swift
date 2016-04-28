//
//  ViewController.swift
//  Pretty Simply Music App
//
//  Created by Marc Aupont on 4/25/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

    @IBOutlet var tableView: UITableView!
    
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet var menuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.target = self.revealViewController()
        menuBtn.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.model.delegate = self
        model.getFeedVideos()
        
        loadSpinner()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    func loadSpinner() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.color = UIColor.init(red: 74.0/255.0, green: 153.0/255.0, blue: 8.0/255.0, alpha: 1)
        view.addSubview(activityIndicator)
        view.alpha = 0.6
        activityIndicator.startAnimating()
        
    }
    
    func stopSpinner() {
        
        activityIndicator.stopAnimating()
        view.alpha = 1.0
    }
    
    //MARK: - VideoModel Delegate Method
    
    func dataReady() {
        
        //Access the video objects that have been downloaded
        self.videos = self.model.videoArray
        
        //Tell the tableview to reload
        self.tableView.reloadData()
        
        stopSpinner()
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return (self.view.frame.size.width / 480) * 360
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell")!
        
        let videoTitle = videos[indexPath.row].videoTitle
        
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        
        let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
        
        if videoThumbnailUrl != nil {
            
            let request = NSURLRequest(URL: videoThumbnailUrl!)
            
            let session = NSURLSession.sharedSession()
            
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    
                    imageView.image = UIImage(data: data!)
                    
                    if indexPath.row == self.videos.count - 1 {
                        
                        self.loadSpinner()
                        self.model.launchReload()
                    }
                    
                })
                
                
                
            })
            
            dataTask.resume()
            
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedVideo = self.videos[indexPath.row]
        
        self.performSegueWithIdentifier("goToDetail", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Get a reference for the destination view controller
        let detailViewController = segue.destinationViewController as! VideoDetailViewController
        
        //Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
        
        
    }


}

