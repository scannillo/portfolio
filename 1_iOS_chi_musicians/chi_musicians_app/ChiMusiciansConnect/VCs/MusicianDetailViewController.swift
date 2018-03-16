//
//  MusicianDetailViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/3/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import WebKit

//This VC describes the page shown when a tableView cell is clicked. Details on each musician.
class MusicianDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    // MARK: Outlets
    @IBOutlet weak var musicianName: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var musicianDescription: UILabel!
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var viewForLoadOverWeb: UIView!
    
    // MARK: Properties
    var userInstance : Users?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.navigationDelegate = self
        
        //Check connectivity
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            badConnectionAlert()
        }
        
        self.showActivityIndicator(uiView: self.view)
        
        if self.userInstance != nil {
            
            //Load text data
            
            if let loadName = userInstance?.musicianName {
                musicianName.text = loadName
            }
            
            if let loadBio = userInstance?.bio {
                if loadBio != "" {
                    bioLabel.text = loadBio
                } else {
                    bioLabel.textColor = UIColor.gray
                    bioLabel.text = "No bio listed."
                }
            }
            
            if let loadDescription = userInstance?.description {
                if loadDescription != "" {
                    musicianDescription.text = loadDescription
                } else {
                    musicianDescription.text = ""
                }
            }
            
            if let loadWebsite = userInstance?.website {
                if loadWebsite != "" {
                   websiteLabel.text = loadWebsite
                } else {
                    websiteLabel.text = "No website listed."
                }
            }
            
            if let loadSongID = userInstance?.songID {
                getVideo(videoCode: loadSongID)
            }
            
            print("User instance prof image: \(userInstance!.profileImage)")
            
            //Load photo data
            if let imageLink = userInstance?.profileImage {
            
                let imageToLoad = SharedNetworking.sharedInstance.linkToImage(link: "\(imageLink)")
                profileImage.image = imageToLoad
                
            } else {
                profileImage.image = UIImage(named: "blankProfile")
            }
        }
        self.hideActivityIndicator(uiView: self.view)

    }
    
    // MARK: - SoundCloud Player
    
    // This function takes the songID attribute on user object and converts it into a SoundCloud link.
    // We then load this soundcloud link to embed into a WebView.
    func getVideo(videoCode: String) {
        print("Load up soundcloud webview called.")
        
        let link1 = "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/"
        let link2 = "&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true"
        
        let url = URL(string : link1+videoCode+link2)
        myWebView.load(URLRequest(url: url!))

    }
    
    //Use this to track if the webview/soundcloud did finish loading.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView did finish loading.")
        viewForLoadOverWeb.backgroundColor = UIColor.clear
    }

    // MARK : - Activity Indicator Functionality
    
    // Attributions: https://github.com/erangaeb/dev-notes/blob/master/swift/ViewControllerUtils.swift
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(origin: .zero, size : CGSize(width: 80, height: 80))
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(origin: .zero, size : CGSize(width: 40, height: 40))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    // MARK: - Network Error Handling
    
    //Alert when no internet
    func badConnectionAlert() {
        let alert = UIAlertController(title: "Bad Connection", message: "Unable to load relevant data.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }
}

