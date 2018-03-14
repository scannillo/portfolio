//
//  MyProfileViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/5/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase
import WebKit

//This VC class houses musician profile information specific to the user who is logged in.
class MyProfileViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var musicianName: UILabel!
    @IBOutlet weak var musicianDescription: UILabel!
    @IBOutlet weak var musicianBio: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var viewForLoadOverWeb: UIView!
    
    // MARK: - Properties
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var dataLoaded = false
    // A cloud storage reference
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.navigationDelegate = self
        loadExistingMusicianData()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name(rawValue: "profileSavePressedEdit"), object: nil, queue: nil, using: catchProfileSavePressed)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if dataLoaded == false {
            loadExistingMusicianData()
        }
        
    }
    
    //Loads the information associated the current user signed in
    func loadExistingMusicianData() {
        
        //Database reference
        let musiciansDB = Database.database().reference().child("musicians")
        
        self.showActivityIndicator(uiView: self.view)
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            badConnectionAlert()
            return
        }
        
        //Observe current snapshot of database
        musiciansDB.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as! [String : [String : String]]
            let allKeys = Array(snapshotValue.keys)
            
            //Check if there is existing data for this user or not
            if allKeys.contains((Auth.auth().currentUser?.uid)!) {
                
                //This is an existing user. Load data.
                print("This is an existing user. Load up.")
                
                self.loadExistingMusicianPhoto()
                
                musiciansDB.child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
                    let snapshotValue = snapshot.value as! Dictionary<String,String>
                    if snapshotValue["musicianName"] != nil {
                        self.musicianName.text = snapshotValue["musicianName"]
                    }
                    
                    if snapshotValue["bio"] != nil {
                        self.musicianBio.text = snapshotValue["bio"]
                    } else {
                        self.musicianBio.text = "No bio provided."
                    }
                    
                    if snapshotValue["description"] != nil {
                        self.musicianDescription.text = snapshotValue["description"]
                    } else {
                        self.musicianDescription.text = "No description."
                    }
                    
                    if snapshotValue["website"] == nil {
                        self.websiteLabel.text = "No website listed."
                    } else if snapshotValue["website"] == "" {
                        self.websiteLabel.text = "No website listed."
                    } else {
                        self.websiteLabel.text = snapshotValue["website"]
                    }
                    
                    if snapshotValue["songID"] != nil {
                        //If a songID has been listed, load it into our soundcloud player.
                        self.getVideo(videoCode: snapshotValue["songID"]!)
                    } else {
                        print("No songID in database for this \(snapshotValue["bio"] ?? "bio")")
                    }
                    
                    self.dataLoaded = true
                    print("Musician data loaded into MyVC")
                }
            } else {
                //This is not an existing user. Leave default data. Don't load up.
                print("This is a registration. No user information yet.")
                self.emptyProfileAlert()
                self.hideActivityIndicator(uiView: self.view)
            }
        })
    }
    
    //This only gets called in the loadExistingMusicianData if they already have a profile.
    func loadExistingMusicianPhoto() {
        
        let dbRef = Database.database().reference()
        dbRef.child("musicians").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // check if user has photo
            if snapshot.hasChild("profileImage") {
                // set image locatin
                let filePath = "\(String(describing: Auth.auth().currentUser?.uid))/profileImage"
                
                print("filePath: \(filePath)")
                
                // Assuming a < 10MB file, though you can change that
                self.storage.reference().child(filePath).getData(maxSize: 10*1024*1024, completion: { (data, error) in
                    
                    if data != nil {
                        if let userPhoto = UIImage(data: data!) {
                            self.profileImage.image = userPhoto
                            print("Profile image was loaded from server.")
                        }
                    } else {
                        print("Profile image was not loaded from server.")
                    }
                    self.hideActivityIndicator(uiView: self.view)
                })
            }
        })
    }
    
    // MARK: - Notification Handler
    func catchProfileSavePressed(notification: Notification) -> Void {
        print("MyVC caught a notification from saved.")
        loadExistingMusicianData()
    }
    
    // MARK: - Soundcloud Player functions
    
    // This function takes the songID attribute on user object and converts it into a SoundCloud link.
    // We then load this soundcloud link to embed into a WebView.
    func getVideo(videoCode: String) {
        
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
    
    // MARK: - IBActions
    
    //Logs out current user. Takes back to welcome screen
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Log out successful.")
            performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        }
        catch {
            print("Error, there was a problem signing out")
        }
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
    
    // MARK: - Alerts
    
    //Alerts when no internet
    func badConnectionAlert() {
        let alert = UIAlertController(title: "Bad Connection", message: "Unable to load relevant data.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }
    
    //Alerts user that their entire profile is empty. Used when first registering a user.
    //Takes them to the 'edit' VC via a segue
    func emptyProfileAlert() {
        let alert = UIAlertController(title: "Your profile is empty!", message: "Fill in musician information.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in self.performSegue(withIdentifier: "editPressed", sender: self)})
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }

}
