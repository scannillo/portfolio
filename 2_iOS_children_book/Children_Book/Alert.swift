//
//  Alert.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/11/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation
import UIKit

// Attribution: - https://www.youtube.com/watch?v=Lrc-MX8WgNc
class Alert {
    
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
