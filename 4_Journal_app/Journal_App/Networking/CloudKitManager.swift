//
//  CloudKitManager.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/17/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

// Attribution: - Andrew Binkowski
open class CloudKitManager {
    
    open static let sharedInstance = CloudKitManager()
    
    // MARK: - Properties
    
    // CloudKit
    let container: CKContainer = CKContainer.default()
    let publicDB: CKDatabase = CKContainer.default().publicCloudDatabase
    let privateDB: CKDatabase = CKContainer.default().privateCloudDatabase
    
    // User
    var userRecordID: CKRecordID?
    
    // Data
    var entries = [CKRecord]()
    
    private init() {}
    
    // MARK: - Modify & Create Records
    
    // Create/Save a Photo entry. Photo entry contains photo, caption, and tags.
    func savePhoto(_ photo: Photo) {
        publicDB.save(photo.record) { record, error in
            if let e = error {
                print("Error saving photo: \(e)")
            } else {
                print("☁️Saved Photo object to cloud!")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .photoSavedToCloud, object: nil)
                }
            }
        }
    }
    
    // MARK: - Queries
    
    func getAllEntries() {
        print("--Get all entries called.")
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        
        let query = CKQuery(recordType: "Photo", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) -> Void in
            if let error = error {
                print("Error: \(String(describing: error.localizedDescription))")
                return
            }
            for record in records! {
                print("📄: \(record["caption"] as! String)")
            }
        }
    }
    
    func cloudToDisk() {
        print("Cloud to Disk called.")
        
        var photos = [PhotoStruct]()
        
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        
        let query = CKQuery(recordType: "Photo", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) -> Void in
            if let error = error {
                print("Error: \(String(describing: error.localizedDescription))")
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .errorSaving, object: nil)
                }
                
                return
            }
            for record in records! {
                if let obj = record["image"] as? CKAsset {
                    
                    let imageURL = SSCache.sharedInstance.saveImage(image: obj.toUIImage()!, Key: record["tags"] as! String)
                    
                    let photoObj = PhotoStruct(caption: record["caption"] as! String, tags: record["tags"] as! String, image: String(describing: imageURL), date: record["date"] as! String, long: record["long"] as! Double, lat: record["lat"] as! Double, recordName: record.recordID.recordName)
                    
                    print("🗒record name: \(record.recordID.recordName)")
                    
                    photos.append(photoObj)
                }
            }
            StructToDisk.sharedInstance.savePostsToDisk(posts: photos)
            print(photos.count)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .finishedSyncing, object: nil)
            }
            
        }
    }
    
    func getImage() {
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        
        let query = CKQuery(recordType: "Photo", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) -> Void in
            if let error = error {
                print("Error: \(String(describing: error.localizedDescription))")
                return
            }
            for record in records! {
                print("We have a record.")
                if let obj = record["image"] as? CKAsset {
                    print("We have a CKAsset/ image.")
                    //print("Do we get an image back: \(obj.toUIImage())")
                    print("File URL of CKAsset: \(obj.fileURL)")
                }
            }
        }
    }
    
    // MARK: - Subscriptions
    
    func registerSubscriptionsWithIdentifiers() {
         
        let uuid: UUID = UIDevice().identifierForVendor!
        
        // **** INSERT **** //
        
        // Create the notification that will be delivered
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "A new Photo entry was created."
        notificationInfo.shouldBadge = true
        
        //????? won't allow me to add image key
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo.desiredKeys = ["image","caption","tags"]
        
        // Create a subscription
        let subscription = CKQuerySubscription(recordType: "Photo",
                                               predicate: NSPredicate(value: true),
                                               subscriptionID: "\(uuid)-insert",
                                               options: [.firesOnRecordCreation])
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription, completionHandler: ({returnRecord, error in
            if let err = error {
                print("Subscription failed \(err.localizedDescription)")
            } else {
                print("Insert supscription set up.")
            }
        }))
        
        // **** DELETE **** //
        
        let notificationInfo2 = CKNotificationInfo()
        notificationInfo2.alertBody = "A Photo entry was deleted."
        notificationInfo2.shouldBadge = true
        
        let subscription2 = CKQuerySubscription(recordType: "Photo",
                                               predicate: NSPredicate(value: true),
                                               subscriptionID: "\(uuid)-delete",
                                               options: [.firesOnRecordDeletion])
        subscription2.notificationInfo = notificationInfo2
        
        publicDB.save(subscription2, completionHandler: ({returnRecord, error in
            if let err = error {
                print("Subscription failed \(err.localizedDescription)")
            } else {
                print("Delete supscription set up.")
            }
        }))
        
        // **** UPDATE **** //
        
        let notificationInfo3 = CKNotificationInfo()
        notificationInfo3.alertBody = "A Photo entry was updated."
        notificationInfo3.shouldBadge = true
        
        let subscription3 = CKQuerySubscription(recordType: "Photo",
                                                predicate: NSPredicate(value: true),
                                                subscriptionID: "\(uuid)-update",
                                                options: [.firesOnRecordUpdate])
        subscription3.notificationInfo = notificationInfo3
        
        publicDB.save(subscription3, completionHandler: ({returnRecord, error in
            if let err = error {
                print("Subscription failed \(err.localizedDescription)")
            } else {
                print("Update supscription set up.")
            }
        }))
    }
}
