//
//  ChatLogViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase

// This displays the actual chat messages between logged in user and chat partner
class ChatLogViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet var messageText: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var messages = [Message]()
    let messagesDB = Database.database().reference().child("messages")
    let userMessagesDB = Database.database().reference().child("userMessages")
    var recipient : Users? {
        didSet {
            navigationItem.title = recipient?.musicianName
            
            observeMessages()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messageText.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        
        // Collection View Settup
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "ChatCollectionViewCell")
        
        // Allow scrolling at all times
        collectionView.alwaysBounceVertical = true
        
        // Leave space above top message
        collectionView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: Load Messages
    
    // Load & organize messages for current recipient
    func observeMessages() {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        } else {
            badConnectionAlert2()
            print("Internet Connection not Available!")
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Invalid userID in attempting to load messages into ChatLogVC")
            return
        }
        
        userMessagesDB.child(uid).observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
            self.messagesDB.child(messageID).observe(.value, with: { (snapshot) in
                print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    print("Couldn't create dictionary from snapshot in observe messages.")
                    return
                }
                
                let message = Message(dictionary: dictionary)
                
                // Check the chat partner and label the cell appropriately
                if self.getChatPartnerID(message: message) == self.recipient?.id {
                
                    self.messages.append(message)
                
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
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
    
    
    // MARK: - Send a message
    
    @IBAction func sendPressed(_ sender: Any) {
        
        // To generate a list of messages with a unique node on each
        let childReference = messagesDB.childByAutoId()
        
        // Get userID of recipiet
        guard let toID = recipient?.id else {
            print("Cannot identify recipient ID.")
            return
        }
        
        // Indentify sender
        guard let fromID = Auth.auth().currentUser?.uid else {
            print("Cannot identify sender ID.")
            return
        }
        
        // Generate message timestamp
        let timestamp = Int(Date().timeIntervalSince1970)
        
        if let message = messageText.text {
            let values = ["text": message, "toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
            
            // We want to save messages in a 'Fan Out' structure. Store the actual message in the "messages" node.
            // Store the reference to the message in the "userMessages" where there is one node per user.
            childReference.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                // Clear text field once message sent
                self.messageText.text = nil
                
                // We want a node PER user that references the key associated with each message
                let userMessagesRef = Database.database().reference().child("userMessages").child(fromID)
                
                let messageID = childReference.key
                userMessagesRef.updateChildValues([messageID: 1])
                
                // We also need messages to be referenced by toID as well
                let recipientMessagesRef = Database.database().reference().child("userMessages").child(toID)
                recipientMessagesRef.updateChildValues([messageID : 1])
            
            }
            print("✉️ Sent: \(messageText.text!)")
        }
    }
    
    // Allows when user hits 'return' or 'enter' for sendPressed to trigger
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendPressed((Any).self)
        return true
    }
}

// MARK: - Configure CollectionView

extension ChatLogViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollectionViewCell", for: indexPath) as! ChatCollectionViewCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        configureCell(cell: cell, message: message)
        
        // Modify cell width
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimatedFrameOfText(text: text).width + 32
        }
        
        return cell
    }
    
    // MARK: - Configure Cells/Bubbles
    
    // Attribution: - https://www.youtube.com/watch?v=azFjJZxZP6M&list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq&index=11
    // Setup bubble cells
    private func configureCell(cell: ChatCollectionViewCell, message: Message) {
        // Message color will depends based on who sent it
        if message.fromID == Auth.auth().currentUser?.uid {
            // Sent messages
            cell.bubbleView.backgroundColor = UIColor.orange
            cell.textView.textColor = UIColor.white
            
            // Move cell to right of screen
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // Recieved messages
            cell.bubbleView.backgroundColor = UIColor.darkGray
            cell.textView.textColor = UIColor.white
            
            // Move cell to left of screen
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
         }
    }
    
    // Make cells span the width of entire view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        // Modify cell height
        if let cellText = messages[indexPath.item].text {
            height = estimatedFrameOfText(text: cellText).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    // Get estimated height of cell based on text
    // Attribution: - https://stackoverflow.com/questions/24107066/nsstring-boundingrectwithsizeoptionsattributescontext-not-usable-in-swift
    func estimatedFrameOfText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        
        return NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    

}
