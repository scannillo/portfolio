//
//  MessagesViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase

// Summary page of all chat partners with current logged in user
class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    let messagesDB = Database.database().reference().child("messages")
    let musiciansDB = Database.database().reference().child("musicians")
    let userMessagesDB = Database.database().reference().child("userMessages")
    var messages : [Message] = [Message]()
    var messagesDictionary = [String: Message]()
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        checkInternet()
        observeMessagesPerUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    // MARK: - Message Networking
    
    func checkInternet() {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert2()
            print("Internet Connection not Available!")
        }
    }
    
    // Find all conversations including the signed in user
    func observeMessagesPerUser() {
        
        // Get current userID
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Look at the userMessages node to see all messages per user
        let reference = userMessagesDB.child(userID)
        reference.observe(.childAdded, with: { (snapshot) in
            
            self.showActivityIndicator2(container: self.container, loadingView: self.loadingView, uiView: self.view, actInd: self.actInd)

            
            // Reference back to the messages node to get actual message
            let messageID = snapshot.key
            let messagesReference = self.messagesDB.child(messageID)
            
            messagesReference.observe(.value, with: { (snapshot) in
                // print(snapshot)
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)

                    // Group messages by recipient toID. Get the last message per recipient
                    if let chatPartnerId = self.getChatPartnerID(message: message) {
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: {(message1, message2) -> Bool in
                            
                            // Sort by most recent message first
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    
                    // Avoid flicker of loaded images
                    var timer = Timer()
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)
                }
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    // Avoid flicker of loaded images
    @objc func timerAction() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            print("Hide act ind")
            self.hideActivityIndicator2(container: self.container, uiView: self.view, actInd: self.actInd)
        })
    }

    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as? ConversationTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        let message = messages[indexPath.row]
        
        // Determine the appropriate name on the message. Could be in the fromID or the toID.
        let chatPartnerId = getChatPartnerID(message: message)
        
        // Get the user's name from their ID# by tapping into the musicianDB
        if let ID = chatPartnerId {
            musiciansDB.child(ID).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    cell.recipientName.text = dictionary["musicianName"] as? String
                }
                
                }, withCancel: nil)
        }
        
        // Set the time label on the message
        if let seconds = message.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            cell.timeLabel.text = timestampDate.toString(dateFormat: "MMM d, h:mm a") // hh:mm:ss a
        }
        
        // Set chat preview of last message
        cell.chatPreview.text = message.text
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatFromConversation" {
            if let destinationVC = segue.destination as? ChatLogViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let message = self.messages[indexPath.row]
                    
                    // Check to see if current user is sender or recipient. get chatPartnerID
                    guard let chatPartnerID = getChatPartnerID(message: message) else {
                        print("Couldn't get chatPartnerID")
                        return
                    }
                    
                    musiciansDB.child(chatPartnerID).observe(.value, with: { (snapshot) in
                        
                        guard let dictionary = snapshot.value as? [String: String] else {
                            print("Error converting snapshot to dictionary.")
                            return
                        }
                        
                        // Get relevant user data and send to ChatLogVC
                        let user = Users()
                        
                        guard let recipientName = dictionary["musicianName"] else {
                            print("No valid username. 🛑 Did not prepare for segue.")
                            return
                        }
                        
                        user.musicianName = recipientName
                        
                        user.id = chatPartnerID
                        destinationVC.recipient = user
                        
                        }, withCancel: nil)
                }
            }
        }
    }
    
    // Determine the appropriate name on the message. Could be in the fromID or the toID.
    func getChatPartnerID(message: Message) -> String? {
        let chatPartnerId: String?
        
        // If the fromID is the current user, the message name should be the toID
        if message.fromID == Auth.auth().currentUser?.uid {
            chatPartnerId = message.toID!
        } else {
            chatPartnerId = message.fromID!
        }
        return chatPartnerId
    }
    

}
