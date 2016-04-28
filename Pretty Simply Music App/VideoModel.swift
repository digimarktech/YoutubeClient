//
//  VideoModel.swift
//  Pretty Simply Music App
//
//  Created by Marc Aupont on 4/25/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    
    func dataReady()
    func videoModelDidUpate()
}

class VideoModel: NSObject {
    
    var loading = false
    
    var videoArray = [Video]()
    
    var nextPageToken = String?()
    
    var playlistItems = [String]()
    
    var menuTitles = [String]()
    
    var delegate:VideoModelDelegate?
    
    func getPlaylistDetails() {
        
        for (var i = 0; i < playlistItems.count; i += 1) {
            
            Alamofire.request(.GET, PLAYLIST_URL, parameters: ["part":"snippet", "id":playlistItems[i], "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                
                //print(response)
    
                if let JSON = response.result.value {
                    
                    for item in JSON["items"] as! NSArray {
                        
                        let menuTitle = item.valueForKeyPath("snippet.title") as! String
                        
                        self.menuTitles.append(menuTitle)
                    }
                    
                    
                }
                
            })
            
            
        }
        
        
    }
    
    func getPlaylistId() {
        
        Alamofire.request(.GET, CHANNEL_SECTIONS_URL, parameters: ["part":"contentDetails", "channelId":CHANNEL_ID, "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            
            
            if let JSON = response.result.value {
                
                for playlistID in JSON["items"] as! NSArray {
                    
                    if let playlists = playlistID.valueForKeyPath("contentDetails.playlists") {
                        
                        if let playlistItem = playlists[0] {
                            
                            self.playlistItems.append(playlistItem as! String)
                        }
                        
                    }
                    
                    
                }
                
                self.getPlaylistDetails()
            }
            
        }
        
    }
    
    
    func getFeedVideos() {
        
        
        //Fetch the videos dynamically through the Youtube Data API
        Alamofire.request(.GET, PLAYLIST_ITEMS_URL, parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "maxResults":"10", "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            
            
            
            if let JSON = response.result.value {
                
                var arrayOfVideos = [Video]()
                
                if let token = JSON.valueForKeyPath("nextPageToken") {
                    
                    self.nextPageToken = String(token)
                }
                
                if let errorCode = JSON.valueForKeyPath("error.code") {
                    
                    var convertedErrorCode = errorCode as! NSInteger
                    
                    if convertedErrorCode == 404 {
                        
                        //Playlist not found
                        print(JSON.valueForKeyPath("error.errors.reason")!)
                    }
                    
                } else {
                    
                    for video in JSON["items"] as! NSArray {
                        
                        //print(video)
                        
                        
                        //Create a video object off of JSON Response
                        let videoObj = Video()
                        
                        //Get all of the content from the JSON response
                        videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                        
                        videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
                        
                        videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
                        
                        if let highResUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                            
                            videoObj.videoThumbnailUrl = highResUrl
                            
                        }
                        
                        if videoObj.videoTitle != "Private video" {
                            
                            arrayOfVideos.append(videoObj)
                        }
                        
                        
                    }
                    
                    //When all of the video objects have been constructed, assign the array to the VideoModel property
                    
                    self.videoArray = arrayOfVideos
                    
                    //Notify the delegate that the data is ready
                    if self.delegate != nil {
                        
                        self.delegate!.dataReady()
                    }
                }
                
                //Callback function
                
                NSNotificationCenter.defaultCenter().postNotificationName("downloadDone", object: nil)
            }
        }
                    
                }
                
                
                
    
    func launchReload() {
        
        if nextPageToken != nil {
            
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "maxResults":"10", "pageToken":"\(nextPageToken!)", "key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
                
                if let JSON = response.result.value {
                    
                    var arrayOfVideos2 = [Video]()
                    
                    if JSON.valueForKeyPath("nextPageToken") == nil {
                        
                        self.nextPageToken = nil
                    }
                    
                    if let npToken = JSON["nextPageToken"] as? String {
                        
                        self.nextPageToken = npToken
                        
                    }
                    
                    
                    for video in JSON["items"] as! NSArray {
                        
                        //print(video)
                        
                        
                        //Create a video object off of JSON Response
                        let videoObj2 = Video()
                        
                        //Get all of the content from the JSON response
                        videoObj2.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                        
                        videoObj2.videoTitle = video.valueForKeyPath("snippet.title") as! String
                        
                        videoObj2.videoDescription = video.valueForKeyPath("snippet.description") as! String
                        
                        if let highResUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                            
                            videoObj2.videoThumbnailUrl = highResUrl
                            
                        }
                        
                        if videoObj2.videoTitle != "Private video" {
                            
                            arrayOfVideos2.append(videoObj2)
                        }
                        
                        
                    }
                    
                    //When all of the video objects have been constructed, assign the array to the VideoModel property
                    
                    self.videoArray += arrayOfVideos2
                    
                    
                    
                    
                    
                    
                    //Notify the delegate that the data is ready
                    if self.delegate != nil {
                        
                        self.delegate!.dataReady()
                    }
                }
            }
        }
        
    }
    
    
}
