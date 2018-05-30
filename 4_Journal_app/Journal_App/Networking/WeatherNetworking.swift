//
//  WeatherNetworking.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation

class WeatherNetworking {
    
    static let sharedInstance = WeatherNetworking()
    
    func generateAPIString(latitude: Double, longitude: Double) -> String {
        let staticLink = "https://api.darksky.net/forecast/0bff5a30dd91cd7c3d607176e53f8b46/\(latitude),\(longitude)"
        return staticLink
    }

    func getData(url: String, completion:@escaping (Weather?, Error?) -> Void) {
        
        // Transform the url parameter argument to a 'URL'
        guard let url = NSURL(string: url) else {
            fatalError("Unable to create NSURL from string")
        }
        
        // Create url session and data task
        let session = URLSession.shared
        
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            // Print response to help debugging process
            print("Response: \(String(describing: response))")
            
            // Ensure there no errors returned from the API request
            guard error == nil else {
                // fatalError("Error: \(error!.localizedDescription)")
                print("Networking error: \(String(describing: error))")
                completion(nil, error)
                return
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                // fatalError("Data is nil")
                print("Data is nil")
                return
            }
            
            // Print out for debugging
            print("Raw data: \(data)")
            
            // Covert JSON to 'Weather' type using 'JSONDecoder' and 'Codable' protocol
            do {
                let decoder = JSONDecoder()
                let weatherObj = try decoder.decode(Weather.self, from: data)
                
                completion(weatherObj, error)
            } catch {
                print("Error serializing/decoding JSON: \(error)")
            }
        })
        task.resume()
    }
    
}

