//
//  StructToDisk.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/18/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

// Attribution: - Andrew Binkowski

import Foundation
import UIKit

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
    
    func imageToData(image: UIImage) -> Data {
        // Make UIImage into Data to save
        let data = UIImagePNGRepresentation(image)
        return data!
    }
    
    // Get a URL to the user's documents directory
    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }

    func savePostsToDisk(posts: [PhotoStruct]) {
        // Create a URL for documents-directory/posts.json
        let url = getDocumentsURL().appendingPathComponent("PhotoStruct.json")
        print("Saving all posts to JSON location: \(url)")
        // Endcode our [PhotoStruct] data to JSON Data
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(posts)
            // Write this data to the url
            try data.write(to: url, options: [])
             print("Saved all photos to disk")
        } catch {
            fatalError(error.localizedDescription)
        }
    }


    func getPostsFromDisk() -> [PhotoStruct] {
        // Create a url for documents-directory/dogs.json
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
            print("Fail on get post from disk.")
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .noLocalData, object: nil
            )}
            //fatalError(error.localizedDescription)
            return []
        }
    }
}
