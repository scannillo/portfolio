//
//  TodayViewController.swift
//  TodayExt
//
//  Created by Samantha Cannillo on 4/26/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var photos = [PhotoStruct]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doesURLExist()
        self.photos = StructToDisk.sharedInstance.getPostsFromDisk()
        collectionView.reloadData()
    }
    
    func doesURLExist() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("PhotoStruct.json") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
            } else {
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photos.count == 0 {
            // Default case if our images don't load
            return 4
        } else {
            return self.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of PhotoCollectionViewCell.")
        }
        
        if self.photos.count == 0 {
            // If no images in JSON, load default images
            cell.imageView.image = UIImage(named: "default")
            return cell
        }
        
        let photoObj = self.photos[indexPath.row]
        cell.imageView.image = SSCache.sharedInstance.getImage(Key: photoObj.tags)
        return cell
        
    }
}

///////*******//////////////******///////******///////******///////******///////******///////******
///////******* This code is re-used from the networking/cloud code above. Is there where creating a custom
///////******* framework come into play? I am confused on the concept of embedded frameworks and they've
///////******* led to app crashes and my data stop working. So given time constraint in finishing other
///////******* parts of the project, this is here for now.

struct PhotoStruct: Codable {
    var caption: String
    var tags: String
    var image: String
    var date: String
    var long: Double
    var lat: Double
    var recordName: String
}

open class StructToDisk {
    
    open static let sharedInstance = StructToDisk()
    
    func getPostsFromDisk() -> [PhotoStruct] {
        // Create a url for documents-directory/PhotoStruct.json
        let url = getDocumentsURL().appendingPathComponent("PhotoStruct.json")
        let decoder = JSONDecoder()
        do {
            // Retrieve the data on the file in this path
            let data = try Data(contentsOf: url, options: [])
            // Decode an array of from this data
            let posts = try decoder.decode([PhotoStruct].self, from: data)
            print("Posts from Disk called: \(posts)")
            return posts
        } catch {
            print("💥Fail on get post from disk.")
            //fatalError(error.localizedDescription)
            return []
        }
    }
    
    // Get a URL to the user's documents directory
    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
    
}

class SSCache: NSObject {
    
    static let sharedInstance = SSCache()
    
    func saveImage(image: UIImage, Key: String) -> URL? {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
            print(filename)
            try? data.write(to: filename)
            return filename
        }
        return nil
    }
    
    func getImage(Key: String) -> UIImage?{
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

