//
// Attribution: - http://iosrevisited.blogspot.com/2017/10/store-and-retrieve-image-locally-swift.html
//

import UIKit
import Foundation

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
