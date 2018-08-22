//
//  WelcomeViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/27/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase

//This VC class is the first screen upon launch. Houses the login and register buttons.
class WelcomeViewController: UIViewController {

    // MARK: - Properties
    var timer : Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.checkLoggedIn()
        })
    }
    
    @objc func checkLoggedIn() {
        
        print("🔑Check log-in status called.")
        
        // Check if user is still logged in
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                print("User already logged in: \(String(describing: user.email))")
                
                // Attribution - https://stackoverflow.com/questions/30592521/opening-view-controller-from-app-delegate-using-swift

                // Launch to home screen if user already logged in
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "MainTabBarController") as UIViewController
                self?.show(initialViewController, sender: self)
                
            } else {
                print("User not logged in")
            }
        }
    }
    
    func stopTimer() {
        // Avoid timer repeats
        guard timer != nil else { return }
        timer?.invalidate()
    }
    
    // MARK: - Segues for Unwind
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }

}
