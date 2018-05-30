//
// Attribution: - https://nsscreencast.com/episodes/266-working-with-images
//

import Foundation
import UIKit
import CloudKit

class Photo {
    
    static let recordType = "Photo"
    
    let record: CKRecord
    
    init(fullsizeImage: UIImage, caption: String, tags: String, date: String, lat: Double, long: Double) {
        record = CKRecord(recordType: Photo.recordType)
        record["caption"] = caption as CKRecordValue
        record["tags"] = tags as CKRecordValue
        record["image"] = CKAsset(image: fullsizeImage, compression: 0.9)
        record["date"] = date as CKRecordValue
        record["long"] = long as CKRecordValue
        record["lat"] = lat as CKRecordValue
    }
}

extension CKAsset {
    convenience init(image: UIImage, compression: CGFloat) {
        let fileURL = ImageHelper.saveToDisk(image: image, compression: compression)
        self.init(fileURL: fileURL)
    }
    
    var image: UIImage? {
        guard let data = try? Data(contentsOf: fileURL),
            let image = UIImage(data: data) else {
                return nil
        }
        
        return image
    }
    
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}


struct ImageHelper {
    static func saveToDisk(image: UIImage, compression: CGFloat = 0.7) -> URL {
        var fileURL = FileManager.default.temporaryDirectory
        let filename = UUID().uuidString
        fileURL.appendPathComponent(filename)
        let data = UIImageJPEGRepresentation(image, compression)!
        try! data.write(to: fileURL)
        return fileURL
    }
}
