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
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var viewForLoadOverWeb: UIView!
    
    // MARK: Properties
    var userInstance : Users?
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
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
            badConnectionAlert2()
        }
        
        self.showActivityIndicator2(container: container, loadingView: loadingView, uiView: self.view, actInd: actInd)
        
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
                    websiteButton.setTitle(loadWebsite, for: .normal)
                } else {
                    websiteButton.setTitle("No website listed.", for: .normal)
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
        self.hideActivityIndicator2(container: container, uiView: self.view, actInd: actInd)
    }
    
    // Button to open Safari to band website
    @IBAction func websitePressed(_ sender: Any) {
        if var loadWebsite = userInstance?.website {
            if loadWebsite != "" {
                if !loadWebsite.isValidForUrl() {
                    loadWebsite = "http://\(loadWebsite)"
                }
                
                if let url = URL(string: loadWebsite) {
                    print("Valid URL")
                    UIApplication.shared.open(url,
                                              options: [:],
                                              completionHandler: { (status) in
                    })
                    
                } else {
                    print("Invalid URL")
                }
            }
        }
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
    
    // MARK: - Message Send Action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatFromMusician" {
            if segue.destination is ChatLogViewController {
                if let destinationVC = segue.destination as? ChatLogViewController {
                    if let user = userInstance {
                        destinationVC.recipient = user
                        destinationVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    }
                }
            }
        }
    }
}

// Check if string is valid to later open in Safari
extension String {
    
    func isValidForUrl() -> Bool {
        if (self.hasPrefix("http://") || self.hasPrefix("https://")) {
            return true
        } else {
            return false
        }
    }
}

