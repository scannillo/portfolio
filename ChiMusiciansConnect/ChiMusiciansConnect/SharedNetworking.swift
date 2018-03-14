//
//  SharedNetworking.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/1/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation
import Firebase

// SharedNetworking class houses networking functionality that is univeral throughout the app
class SharedNetworking {
    
    //MARK: Properties
    static let sharedInstance = SharedNetworking()
    let storage = Storage.storage()
    
    //Initialization
    private init() {}
    
    func linkToImage(link: String) -> UIImage? {
        var image: UIImage
        let url = URL(string: link)
        if let data = try? Data(contentsOf: url!) {
            // change contentsOf (executes on main thread) instead to task = session.dataTask (background)
            image = UIImage(data: data)!
        } else {
            return UIImage(named : "blankProfile")
        }
        return image
    }
    
    
    // Attributions: - Andrew Binkowski course playground
    // Resize an image based on a scale factor
    func resize(image: UIImage, scale: CGFloat) -> UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: scale,y: scale))
        let hasAlpha = true
        
        // Automatically use scale factor of main screen
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("An image was resized")
        return scaledImage!
    }
}
