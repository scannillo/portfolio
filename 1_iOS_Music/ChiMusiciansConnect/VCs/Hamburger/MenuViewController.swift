//
//  MenuViewController.swift
//  
//
//  Created by Samantha Cannillo on 5/16/18.
//

import UIKit
import Firebase
import FBSDKLoginKit

// Menu that shows from hamburger button
class MenuViewController: UIViewController {
    
    // MARK: - Actions
    @IBAction func editProfilePressed(_ sender: Any) {
    }
    
    // Logs a user out of their app session under their email/password. Takes back to welcome screen.
    // Attributions: - https://medium.com/@mimicatcodes/create-unwind-segues-in-swift-3-8793f7d23c6f
    @IBAction func logOutPressed(_ sender: Any) {
        logoutAlert()
    }
    
    // MARK: - Alerts
    
    // Double check if user wants to log out
    func logoutAlert() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let okay = UIAlertAction(title: "Yes", style: .cancel) { (action) in
            self.logout()
        }
        alert.addAction(cancel)
        alert.addAction(okay)
        cancel.setValue(UIColor.darkGray, forKey: "titleTextColor")
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }
    
    func logout() {
        
        // Logout of Firebase
        do {
            try Auth.auth().signOut()
            print("Log out successful.")
            performSegue(withIdentifier: "unwindToVC1", sender: self)
        }
        catch {
            print("Error, there was a problem signing out")
        }
        
        // Logout of Facebook in App
        let manager = FBSDKLoginManager()
        manager.logOut()
    }
    
}
