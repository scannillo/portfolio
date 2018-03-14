//
//  LoginViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/27/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase

//This VC class checks all log in information is valid
class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Log in an existing user. Only segue them into the main part of the app if login successfull
    @IBAction func logInPressed(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert()
            print("Internet Connection not Available!")
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            //Check for errors
            if error != nil {
                print("Log in error: \(error!)")
                
                self.alertBadLogin()
            } else {
                print("Log in successful.")
                self.performSegue(withIdentifier: "showMainFromLogin", sender: self)
            }
        }
    }
    
    // MARK: - IBActions
    
    //Go back to welcome screen
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Alerts
    
    //Show alert if login unsuccesfull
    func alertBadLogin() {
        let alert = UIAlertController(title: "Login Failed",
                                      message: "Invalid credentials. Try again.",
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Network Error Handling
    
    //Show alert if no internet connection
    func badConnectionAlert() {
        let alert = UIAlertController(title: "Bad Connection", message: "No internet available.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }

}
