//
//  Message.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/3/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation

class Message: NSObject {
    var fromID: String?
    var toID: String?
    var timestamp: NSNumber?
    var text: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromID = dictionary["fromID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toID = dictionary["toID"] as? String
    }
}
