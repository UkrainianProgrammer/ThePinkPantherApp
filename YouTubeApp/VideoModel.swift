//
//  VideoModel.swift
//  YouTubeApp
//
//  Created by Oleksandr Sofishchenko on 7/19/16.
//  Copyright © 2016 Oleksandr Sofishchenko. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyBtqOnoktl1gFArdU190t32oFTXR8igNik"
    let UPLOADS_PLAYLIST_ID = "UUFeUyPY6W8qX8w2o6oSiRmw"
    
    var videoArray = [Video]()
    var delegate:VideoModelDelegate?
    
    func getFeedVideos() {
        
        //fetch the videos dynamically through the YouTube Data API
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "maxResults": 50, "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            if let JSON = response.result.value{
                
                var arrayOfVideos = [Video]()
                
                for video in JSON["items"] as! NSArray{
                    //print(video)
                    
                    //create video objs off of JSON response
                    let videoObj = Video()
                    videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                    videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
                    videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
                    videoObj.videoThumbnailURL = video.valueForKeyPath("snippet.thumbnails.high.url") as!
                        String
                    arrayOfVideos.append(videoObj)
                }
                
                //assign the array to the video model property
                self.videoArray = arrayOfVideos
                
                //notify delegate that data is ready
                if self.delegate != nil{
                    self.delegate!.dataReady()
                }
            }
        }
    }
    
    func getVideos() -> [Video] {
        
        var videos = [Video]()
        
        //Create a video obj and assign props
        let video1 = Video()
        video1.videoId = "ObV6-zeFlE4"
        video1.videoTitle = "The Pink Panther in \"Slink Pink\""
        video1.videoDescription = "Pink finds himself hiding in a hunter's house."
        
        let video2 = Video()
        video2.videoId = "mq8kTMrcjtc"
        video2.videoTitle = "The Pink Panther in \"Pink-In\""
        video2.videoDescription = "Pink reads some old letters from his army friend Loud Mouth Louie."
        
        //append objs to the array
        videos.append(video1)
        videos.append(video2)
        
        return videos
        
    }
}
