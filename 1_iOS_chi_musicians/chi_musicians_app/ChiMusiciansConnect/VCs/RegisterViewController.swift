//
//  RegisterViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/27/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase

//This VC checks if registration materials provided are valid
class RegisterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    
    //This function allows a user to create username and passsord to use in our firebase/app.
    @IBAction func registerPressed(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert()
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
    
    // MARK: - Network Error Handling
    
    //Show alert if no network/internet connection
    func badConnectionAlert() {
        let alert = UIAlertController(title: "Bad Connection", message: "No internet available.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }

}
