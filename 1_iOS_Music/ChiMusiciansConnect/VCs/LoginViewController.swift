//
//  LoginViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/27/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

//This VC class checks all log in information is valid
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup corner radius on buttons
        emailButton.backgroundColor = UIColor.orange
        emailButton.layer.cornerRadius = 8
        emailButton.layer.borderWidth = 1
        emailButton.layer.borderColor = UIColor.orange.cgColor
        
        facebookButton.backgroundColor = UIColor(hue: 216/360, saturation: 100/100, brightness: 99/100, alpha: 1.0)
        facebookButton.layer.cornerRadius = 8
        facebookButton.layer.borderWidth = 1
        facebookButton.layer.borderColor = UIColor(hue: 216/360, saturation: 100/100, brightness: 99/100, alpha: 1.0).cgColor
    }
    
    // MARK: - FBSDKLogin Delegate Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("📘Error logging in with Facebook.")
        } else {
            print("📘Successful login with Facebook.")
        }
        
        self.connectToFirebase()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook.")
    }
    
    // MARK: - Login Via Facebook
    
    // Connect to user's facebook
    @IBAction func customFBPressed(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("📘Error logging in with Facebook: \(String(describing: error))")
                self.alertBadLogin()
                return
            } else {
                print("📘Successful login with Facebook.")
                self.connectToFirebase()
            }
        }
    }
    
    // After connecting to facebook, connect to firebase via token
    func connectToFirebase() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Error logging into Firebase with FBUser: \(String(describing: error))")
                return
            } else {
                print("👤Successful login to Firebase with FBuser.")
                self.performSegue(withIdentifier: "showMainFromLogin", sender: self)
            }
        }
    }

    
    // MARK: - Login Via Email
    
    //Log in an existing user. Only segue them into the main part of the app if login successfull
    @IBAction func logInPressed(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert2()
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
    
    // Show alert with text field to recover password
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Password Resert",
                                      message: "Enter email to receive password reset link.",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        cancel.setValue(UIColor.darkGray, forKey: "titleTextColor")

        let submitAction = UIAlertAction(title: "Reset", style: .cancel, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            
            if let email = textField.text {
                if email != "" {
                    self.resetPassword(email: email)
                }
            }
        })
        submitAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        // Add TextField and customize
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter Email"
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addAction(cancel)
        alert.addAction(submitAction)

        present(alert, animated: true, completion: nil)
    }
    
    // Call to firebase to reset password
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                self.passwordSent(email: email)
                print("✉️ Password reset sent to: \(email)")
            }else {
                print(error!.localizedDescription)
                print("📤 Password reset error.")
            }
        })
        
    }
    
    // MARK: - Alerts
    
    // Alert that password reset was indeed sent to email
    func passwordSent(email: String) {
        let alert = UIAlertController(title: "Password Reset",
                                      message: "Email with reset link sent to \(email).",
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        present(alert, animated: true, completion: nil)
    }
    
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
}
