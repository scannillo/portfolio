//
//  SettingsViewController.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/17/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import CloudKit

class SettingsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    // MARK: - Properties
    var actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let container: CKContainer = CKContainer.default()
    var userRecordID: CKRecordID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameFinder()
        
        actInd.center = view.center
        
        // Stop Activity Indicator when we finish syncing
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(stopAnimation),
                                       name: .finishedSyncing,
                                       object: nil)
        
    }

    // Attributions: - Andrew Binkowski
    func userNameFinder() {
        
        userNameLabel.text = "Username Not Found"
        userNameLabel.textColor = UIColor.gray
        
        // Get the currently logged in user record
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let recordID = recordID {
                    self.userRecordID = recordID
                }
            }
        }
        
        // Get the user permissions
        container.requestApplicationPermission(.userDiscoverability) { (status, error) in
            guard status == .granted, error == nil else {
                DispatchQueue.main.async {
                    self.userNameLabel.text = "NOT AUTHORIZED"
                }
                return
            }
            
            // Get the user name
            self.container.discoverUserIdentity(withUserRecordID: self.userRecordID!, completionHandler: {
                (userID, error) in
                let userName = (userID?.nameComponents?.givenName)! + " " + (userID?.nameComponents?.familyName)!
                print("User Name: " + userName)
                DispatchQueue.main.async {
                    self.userNameLabel.text = userName
                    self.userNameLabel.textColor = UIColor.black
                }
            })
        }
    }
    
    @IBAction func syncPressed(_ sender: Any) {
        actInd.startAnimating()
        doneButton.isEnabled = false
        doneButton.tintColor = UIColor.gray
        view.addSubview(actInd)
        CloudKitManager.sharedInstance.cloudToDisk()
    }
    
    @objc func stopAnimation() {
        doneButton.isEnabled = true
        doneButton.tintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.97, alpha: 1.0)
        actInd.stopAnimating()
    }
    
}


