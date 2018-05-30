//
//  DetailViewController.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/22/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import CloudKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextView!
    @IBOutlet var tagField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Properties
    var allPhotos : [PhotoStruct]?
    var photoInstance : PhotoStruct?
    let publicDB: CKDatabase = CKContainer.default().publicCloudDatabase
    var actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        actInd.center = view.center
        
        // Load photo data into VC
        if let caption = photoInstance?.caption {
            self.textField.text = caption
        }
        
        if let tags = photoInstance?.tags {
            self.tagField.text = tags
            if (photoInstance?.image) != nil {
                self.imageView.image = SSCache.sharedInstance.getImage(Key: tags)
            }
        }
        
        if let date = photoInstance?.date {
            dateLabel.text = date
        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Used to tell our activity indicator to stop once edit successully posted to cloud
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(stopSpinning),
                                       name: .finishedPostingEditToCloud,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(alertSaveError),
                                       name: .errorSaving,
                                       object: nil)
        
    }
    
    // MARK: - Cloud Editing/Deleting
    
    func editRecord() {
        // Get the data we want to edit
        var editedCaption = ""
        var editedTags = ""
        
        if let caption = self.textField.text {
            editedCaption = caption
        }
        
        if let tags = self.tagField.text {
            editedTags = tags
        }
        
        // Check that this photo entry has a record name
        guard let recName = photoInstance?.recordName else {
            print("No recordName exists")
            return
        }
        
        // Get corresponding recordID from recordName
        let getID = CKRecordID(recordName: recName)
        
        // Read data
        publicDB.fetch(withRecordID: getID) { recordN, error in
            
            guard error == nil else {
                print("Edit fetch Error: \(String(describing: error?.localizedDescription))")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .errorSaving, object: nil)
                }
                return
            }
            
            guard let record = recordN else {
                print("Record- \(recName) was nil")
                return
            }
            
            // Edit data
            record["caption"] = editedCaption as CKRecordValue
            record["tags"] = editedTags as CKRecordValue
            
            // Save data
            self.publicDB.save(record) { (record, error) in
                if let error = error {
                    print("Edit save Error: \(error.localizedDescription)")
                    return
                }
                //print("☁️Edit record successful: \(record.debugDescription)")
                print("☁️Edit record successful.")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .finishedPostingEditToCloud, object: nil)
                }
            }
        }
    }
    
    func deleteAction() {
        // Check that this photo entry has a record name
        guard let recName = photoInstance?.recordName else {
            print("No recordName exists")
            return
        }
        
        // Get corresponding recordID from recordName
        let getID = CKRecordID(recordName: recName)
        
        publicDB.delete(withRecordID: getID, completionHandler: ({ (record, error) in
            if let error = error {
                print("Deletion Error: \(error.localizedDescription)")
                return
            } else {
                print("🌩 Deletion successful.")
            }
        }))
    }
    
    // MARK: - Local Editing/Deleting

    func localEdit() {
        
        // Get the data we want to edit
        var editedCaption = ""
        var editedTags = ""
        
        if let caption = self.textField.text {
            editedCaption = caption
        }
        
        if let tags = self.tagField.text {
            editedTags = tags
        }
        
        // Check for valid record name
        guard let currentRecordName = photoInstance?.recordName else {
            print("No record Id. Can't edit entry locally.")
            return
        }
        
        // Check for valid photos array
        guard var photos = allPhotos else {
            print("Empty photos array. Can't edit locally.")
            return
        }
        
        // Edit this current photo instance
        for (index, photo) in photos.enumerated() {
            if photo.recordName == currentRecordName {
                let newPhoto = PhotoStruct(caption: editedCaption, tags: editedTags, image: photo.image, date: photo.date, long: photo.long, lat: photo.lat, recordName: photo.recordName)
                photos.remove(at: index)
                photos.append(newPhoto)
                print("📸Succesfully locally edited entry!")
            }
        }
        StructToDisk.sharedInstance.savePostsToDisk(posts: photos)
    }
    
    func localDelete() {
        guard let currentRecordName = photoInstance?.recordName else {
            print("No record Id. Can't edit entry locally.")
            return
        }
        
        guard var photos = allPhotos else {
            print("Empty photos array. Can't edit locally.")
            return
        }
        
        // Remove this current photo instance
        for (index, photo) in photos.enumerated() {
            if photo.recordName == currentRecordName {
                photos.remove(at: index)
                print("📸Succesfully deleted local entry!")
            }
        }
        StructToDisk.sharedInstance.savePostsToDisk(posts: photos)
        
        // Navigate back to the mainVC
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - IBActions
    
    @IBAction func deletePressed(_ sender: Any) {
        alertDelete()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        actInd.startAnimating()
        view.addSubview(actInd)
        editRecord()
        localEdit()
    }
    
    @objc func stopSpinning() {
        actInd.stopAnimating()
    }
    
    // MARK: - Alert
    
    func alertDelete() {
        
        let alert = UIAlertController(title: "Are you sure you want to delete this  photo?",
                                      message: "It will be removed from your Journal.",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteAction()
            self.localDelete()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertSaveError() {
        actInd.stopAnimating()
        
        let alert = UIAlertController(title: "Error saving to iCloud. Data will persist locally.",
                                      message: "Check internet connection and try again.",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(submitAction)
        self.present(alert, animated: true)
    }
}
