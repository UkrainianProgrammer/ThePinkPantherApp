//
//  ViewController.swift
//  YouTubeApp
//
//  Created by Oleksandr Sofishchenko on 7/19/16.
//  Copyright © 2016 Oleksandr Sofishchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

    @IBOutlet var tableView: UITableView!
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.videos = VideoModel().getVideos()
        self.model.delegate = self
        
        //fire a request to get videos
        model.getFeedVideos()
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: videoModel delegate methods
    func dataReady() {
        
        //access the video objs that have been downloaded
        self.videos = self.model.videoArray
        
        //tell the tableView to reload
        self.tableView.reloadData()
        
    }
    
    //MARK: tableView delegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //get the width of the screen to calculate the width of the row
        return (self.view.frame.size.width / 320) * 180
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
        
        let videoTitle = videos[indexPath.row].videoTitle
        
        //get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        //construct video thumbnail url 
        let videoThumbnailURLString = videos[indexPath.row].videoThumbnailURL
        //create a NSURL obj
        let videoThumbnailURL = NSURL(string: videoThumbnailURLString)
        
        if(videoThumbnailURL != nil){
            
            //create a NSURL request obj
            let request = NSURLRequest(URL: videoThumbnailURL!)
            
            //create a NSURL session
            let session = NSURLSession.sharedSession()
            
            //create a data task and pass in the request
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //get a referrence to the imageview element of the cell
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    
                    //create an image obj from the data and assign it into the imageview
                    imageView.image = UIImage(data: data!)
                    
                })
                
            })
            
            dataTask.resume()
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //take note of which video user selected
        self.selectedVideo = self.videos[indexPath.row]
        
        //call the segue
        self.performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //get a reference to the destnation view controller 
        let detailViewController = segue.destinationViewController as! VideoDetailViewController
        
        
        //set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
}

