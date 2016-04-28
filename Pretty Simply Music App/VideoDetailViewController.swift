//
//  VideoDetailViewController.swift
//  Pretty Simply Music App
//
//  Created by Marc Aupont on 4/26/16.
//  Copyright © 2016 Digimark Technical Solutions. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descLabel: UITextView!
    
    var selectedVideo:Video?
    
    @IBOutlet var webViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.hidden = true
        descLabel.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        
        if let vid = self.selectedVideo {
            
            self.titleLabel.text = vid.videoTitle
            self.descLabel.text = vid.videoDescription
            
            titleLabel.hidden = false
            descLabel.hidden = false
            
            let width = self.view.frame.size.width
            let height = width / 560 * 315
            
            //Adjust the height of the webview constraint
            self.webViewHeightConstraint.constant = height
            
            let videoEmbedString = "<html><head><style type=\"text/css\">body {background-color:transparent; color: white;}</style></head><body style=\"margin:0\"><iframe width=\"" + String(width) + "\" height=\"" + String(height) + "\" src=\"https://www.youtube.com/embed/" + vid.videoId + "\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
            
            
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
        }
    }
    

    

}
