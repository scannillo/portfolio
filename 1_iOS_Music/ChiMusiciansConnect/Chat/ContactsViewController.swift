//
//  ContactsViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

// Displays all users of the DIY CHI app as contacts for the signed in user
class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    var musiciansArray : [Users] = [Users]()
    var messagesController: MessagesViewController?
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70.0
        retrieveMusicians()
    }

    //This function retrieves all current musician data in firebase. Loads into local musiciansArray
    func retrieveMusicians() {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert2()
            print("Internet Connection not Available!")
        }
        
        self.musiciansArray.removeAll()
        
        //Start spinner
        showActivityIndicator2(container: container, loadingView: loadingView, uiView: self.view, actInd: actInd)
        
        //Reference to our databse section "musicians"
        let musiciansDB = Database.database().reference().child("musicians")
        
        //This gets a current snapshot of all data in database
        musiciansDB.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as! [String : [String : String]]
            
            //All of the keys are userIDs of current musicians
            let allKeys = Array(snapshotValue.keys)
            
            //Use keys to access musician data
            for key in allKeys {
                let usersInstance = Users()
                usersInstance.id = key
                if let dict = snapshotValue[key] {
                    
                    if let loadName = dict["musicianName"] {
                        usersInstance.musicianName = loadName
                    }
                    
                    if let loadFilePath = dict["filePath"] {
                        usersInstance.filePath = loadFilePath
                    }
                    
                    if let loadEmail = dict["email"] {
                        usersInstance.email = loadEmail
                    }
                    
                    // Do this check so we don't include the current user in their own contacts list
                    if key != Auth.auth().currentUser?.uid {
                        self.musiciansArray.append(usersInstance)
                    }
                    print("We added data to musiciansArray for the userID: \(key)")
                }
            }
            print("Reached end of retrieve completion block.")
            self.tableView.reloadData()
            self.hideActivityIndicator2(container: self.container, uiView: self.view, actInd: self.actInd)
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musiciansArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        cell.name.text = musiciansArray[indexPath.row].musicianName
        cell.email.text = musiciansArray[indexPath.row].email
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    // Pass data to ChatLogController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showChatController" {
            if let destinationVC = segue.destination as? ChatLogViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let user = self.musiciansArray[indexPath.row]
                    destinationVC.recipient = user
                }
            }
        }
    }
    
}
