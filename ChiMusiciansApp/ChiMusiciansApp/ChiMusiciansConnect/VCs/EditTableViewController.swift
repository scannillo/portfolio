//
//  EditTableViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/5/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase

//This VC class allows editing of the user profile that is currently logged in.
class EditTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var musicianName: UITextField!
    @IBOutlet weak var musicianDescription: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var songIDTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: - Properties
    let storage = Storage.storage()
    let imagePicker = UIImagePickerController()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExistingMusicianData()
    }

    //Loads the information associated with this user signed in
    func loadExistingMusicianData() {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert()
            print("Internet Connection not Available!")
        }
        
        //Database reference
        let musiciansDB = Database.database().reference().child("musicians")
        
        //Observe current snapshot of database
        musiciansDB.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as! [String : [String : String]]
            let allKeys = Array(snapshotValue.keys)
            
            //Check if there is existing data for this user or not
            if allKeys.contains((Auth.auth().currentUser?.uid)!) {
                
                //This is an existing user. Load data.
                print("this is an existing user. Load up.")
                self.loadExistingMusicianPhoto()
                self.showActivityIndicator(uiView: self.view)
                
                musiciansDB.child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
                    let snapshotValue = snapshot.value as! Dictionary<String,String>
                    
                    if snapshotValue["musicianName"] != nil {
                        self.musicianName.text = snapshotValue["musicianName"]
                    }
                    
                    if snapshotValue["bio"] != nil {
                        self.bioText.text = snapshotValue["bio"]
                    }
                    
                    if snapshotValue["description"] != nil {
                        self.musicianDescription.text = snapshotValue["description"]
                    }
                    
                    if snapshotValue["website"] != nil {
                        self.websiteText.text = snapshotValue["website"]
                    }
                    
                    if snapshotValue["songID"] != nil {
                        self.songIDTextField.text = snapshotValue["songID"]
                    }
                    
                    print("Musician data loaded.")
                }
            } else {
                //This is not an existing user. Leave default data. Don't load.
                print("No user information.")
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
                            
                            let resizedImage = SharedNetworking.sharedInstance.resize(image: userPhoto, scale: 0.3)
                    
                            self.profileImage.image = resizedImage
                            
                            self.hideActivityIndicator(uiView: self.view)
                            print("Profile image was loaded from server.")
                        }
                    } else {
                        print("Profile image was not loaded from server.")
                    }
                })
            }
        })
    }

    // MARK: - Image Picker
    @IBAction func uploadImage(_ sender: Any) {
        print("Edit image pressed.")
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            print("An image was picked")

            print("Profile image placed temporarily in imageView")
            profileImage.image = image
            
            imagePicker.dismiss(animated: true, completion: nil)
            
        } else {
            
            print("There was an error picking the image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - IBActions
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Saves all current data in edit page to firebase
    @IBAction func savePressed(_ sender: Any) {
        
        print("save pressed")
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            unableToSave()
            print("Internet Connection not Available!")
            return
        }
        
        //Start spinner
        showActivityIndicator(uiView: view)
        
        uploadImage(profileImage: profileImage.image!)
        
        //Disable text fields and button action
        musicianName.isEnabled = false
        bioText.isEditable = false
        saveButton.isEnabled = false
        cancelButton.isEnabled = false
        
        //Each musician profile will be its own dictionary in Firebase
        let musiciansDB = Database.database().reference().child("musicians")
        
        let currentEmail = Auth.auth().currentUser?.email
        
        musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["email": currentEmail!])
        
        if let editedName = musicianName.text {
            musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["musicianName": editedName])
        }
        
        if let editedBio = bioText.text {
            musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["bio": editedBio])
        }
        
        musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["filePath": "\(String(describing: Auth.auth().currentUser?.uid))/profileImage"])
        
        if let editedWebsite = websiteText.text {
            musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["website": editedWebsite])
        }
        
        if let editedDescription = musicianDescription.text {
            musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["description": editedDescription])
        }
        
        if let editedSongID = songIDTextField.text {
            musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["songID": editedSongID])
        }
    }
    
    
    // Attribution : https://stackoverflow.com/questions/37780672/uploading-images-from-uiimage-picker-onto-new-firebase-swift
    // Upload profile image to firebase. Called within savePressed
    func uploadImage(profileImage : UIImage) {
        
        //Convert UIImage to Data
        var data = Data()
        data = UIImageJPEGRepresentation(profileImage, 0.8)!
        
        //Database reference
        let musiciansDB = Database.database().reference().child("musicians")
        
        //Set upload path
        let filePath = "\(String(describing: Auth.auth().currentUser?.uid))/profileImage"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        print("filePath: \(filePath)")
        self.storage.reference().child(filePath).putData(data, metadata: metaData) {(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                musiciansDB.child((Auth.auth().currentUser?.uid)!).updateChildValues(["profileImage": downloadURL])
                print("Photo uploaded successfully to server.")
                
                //Re-enable text fields and buttons
                //Don't want user to interupt saving process
                self.musicianName.isEnabled = true
                self.bioText.isEditable = true
                self.saveButton.isEnabled = true
                self.cancelButton.isEnabled = true
                
                //Broadcast save pressed notification to TableViewController class
                let nc = NotificationCenter.default
                                
                nc.post(name: Notification.Name(rawValue: "profileSavePressedTable"), object: nil, userInfo: ["message" : "Save profile pressed", "date" : Date()])
                nc.post(name: Notification.Name(rawValue: "profileSavePressedEdit"), object: nil, userInfo: ["message" : "Save profile pressed", "date" : Date()])
                print("We made a broadcast post")
                
                //Turn spinner off
                self.hideActivityIndicator(uiView: self.view)
                
                //Close modal edit screen
                self.dismiss(animated: true, completion: nil)
            }
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
    
    // MARK: - Network Error Handling
    
    //Alert when no internet
    func badConnectionAlert() {
        let alert = UIAlertController(title: "Bad Connection", message: "No internet available.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }
    
    //Alert when connection problems prevents proper saving.
    func unableToSave() {
        let alert = UIAlertController(title: "Bad Connection", message: "Profile information not saved.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }
    
}
