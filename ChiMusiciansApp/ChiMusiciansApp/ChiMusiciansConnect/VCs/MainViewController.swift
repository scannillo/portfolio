//
//  MainViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/3/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

//This houses the tableView with all musicians who have profiles in our database.
class MainViewController: UIViewController, UITableViewDataSource {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var musiciansArray : [Users] = [Users]()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        retrieveMusicians()
        tableView.rowHeight = 90.0
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name(rawValue: "profileSavePressedTable"), object: nil, queue: nil, using: catchProfileSavePressed)
    }
    
    //This function retrieves all current musician data in firebase. Loads into local musiciansArray
    func retrieveMusicians() {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            badConnectionAlert()
        }
        
        print("Retrieve musicians called. We will begin loading!")
        self.musiciansArray.removeAll()
        
        //Start spinner
        showActivityIndicator()
        
        //Reference to our databse section "musicians"
        let musiciansDB = Database.database().reference().child("musicians")
        
        //This gets a current snapshot of all data in database
        musiciansDB.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as! [String : [String : String]]
            
            //All of the keys are userIDs of current musicians
            let allKeys = Array(snapshotValue.keys)
            print("All keys: \(allKeys)")
            
            //Use keys to access musician data
            for key in allKeys {
                print("key instance is \(key)")
                let usersInstance = Users()
                if let dict = snapshotValue[key] {
                    
                    if let loadName = dict["musicianName"] {
                        usersInstance.musicianName = loadName
                    }
                    
                    if let loadBio = dict["bio"] {
                        usersInstance.bio = loadBio
                    }
                    
                    if let loadProfileImage = dict["profileImage"] {
                        usersInstance.profileImage =  loadProfileImage
                    }
                    
                    if let loadFilePath = dict["filePath"] {
                        usersInstance.filePath = loadFilePath
                    }
                    
                    if let loadEmail = dict["email"] {
                        usersInstance.email = loadEmail
                    }
                    
                    if let loadWebsite = dict["website"] {
                        usersInstance.website = loadWebsite
                    }
                    
                    if let loadDescription = dict["description"] {
                        usersInstance.description = loadDescription
                    }
                    
                    if let loadSongID = dict["songID"] {
                        usersInstance.songID = loadSongID
                    }
                    
                    self.musiciansArray.append(usersInstance)
                    print("We added data to musiciansArray for the userID: \(key)")
                }
            }
            print("Reached end of retrieve completion block.")
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Notification Handler
    
    //Catches notification from "Save" button upod editing a user profile. Cascade update throughout app.
    func catchProfileSavePressed(notification: Notification) -> Void {
        print("Table view caught a notification from save.")
        retrieveMusicians()
    }
    
    // MARK: - Network Error Handling
    
    //Presents alert when no internet
    func badConnectionAlert() {
        let alert = UIAlertController(title: "Bad Connection", message: "No internet available.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musiciansArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }
        
        cell.musicianName.text = musiciansArray[indexPath.row].musicianName
        cell.musicianDetail.text = musiciansArray[indexPath.row].description
        
        print("We loaded a profile image at cell: \(indexPath.row)")
   
        //Load profile images into cells
        Alamofire.request(musiciansArray[indexPath.row].profileImage).responseData {
            response in
            
            if let data = response.result.value {
                cell.profileImage.image  = UIImage(data: data)
            }
        }
        
        if indexPath.row == self.musiciansArray.count - 1 {
            self.hideActivityIndicator()
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    // MARK: - Activity Indicator Methods
    
    func showActivityIndicator() {
        actInd.center = view.center
        self.actInd.startAnimating()
        view.addSubview(actInd)
    }
    
    func hideActivityIndicator() {
        self.actInd.stopAnimating()
        self.actInd.removeFromSuperview()
    }
    
    // MARK: - IBActions
    
    // Logs a user out of their app session under their email/password. Takes back to welcome screen.
    // Attributions: - https://medium.com/@mimicatcodes/create-unwind-segues-in-swift-3-8793f7d23c6f
    @IBAction func logOutButton(_ sender: Any) {        
        do {
            try Auth.auth().signOut()
            print("Log out successful.")
            self.performSegue(withIdentifier: "unwindToWelcome", sender: self)
        }
        catch {
            print("Error, there was a problem signing out")
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            badConnectionAlert()
            return
        }
        
        if segue.identifier == "showMusicianDetail" {
            if let destinationVC = segue.destination as? MusicianDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let user = self.musiciansArray[indexPath.row]
                        destinationVC.userInstance = user
                }
            }
        }
    }
}


