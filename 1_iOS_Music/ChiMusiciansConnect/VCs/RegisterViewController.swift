//
//  RegisterViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/27/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

//This VC checks if registration materials provided are valid
class RegisterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup corner radius on email button
        registerButton.backgroundColor = UIColor.orange
        registerButton.layer.cornerRadius = 4
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.orange.cgColor
        
        facebookButton.backgroundColor = UIColor(hue: 216/360, saturation: 100/100, brightness: 99/100, alpha: 1.0)
        facebookButton.layer.cornerRadius = 4
        facebookButton.layer.borderWidth = 1
        facebookButton.layer.borderColor = UIColor(hue: 216/360, saturation: 100/100, brightness: 99/100, alpha: 1.0).cgColor
    }
    
    //MARK: - Register Via Email
    
    //This function allows a user to create username and passsord to use in our firebase/app.
    @IBAction func registerPressed(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert2()
            print("Internet Connection not Available!")
        }
        
        //Tap into firebase authentication class
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            //Authentication completed and callback triggered
            if error != nil {
                //There is an error
                print("Bad registration attempt. \(error!)")
                self.alertBadRegistration()
            } else {
                print("Registration success.")
                self.performSegue(withIdentifier: "showMainFromRegister", sender: self)
            }
        }
    }
    
    
    //MARK: - Register Via Facebook
    
    // Log in through Facebook, then send info to Firebase
    @IBAction func registerFacebook(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("📘Error logging in with Facebook: \(String(describing: error))")
                self.alertBadRegistration()
                return
            } else {
                print("📘Successful login with Facebook.")
                self.connectToFirebase()
            }
        }
    }
    
    // Connect user info from FB to Firebase
    func connectToFirebase() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Error logging into Firebase with FBUser: \(String(describing: error))")
                self.alertBadRegistration()
                return
            } else {
                print("👤Successful login to Firebase with FBuser.")
                self.performSegue(withIdentifier: "showMainFromRegister", sender: self)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Alerts
    
    //Show alert if registration unsuccesfull
    func alertBadRegistration() {
        let alert = UIAlertController(title: "Registration Failed",
                                      message: "Invalid credentials. Try again.",
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        present(alert, animated: true, completion: nil)
    }

}
