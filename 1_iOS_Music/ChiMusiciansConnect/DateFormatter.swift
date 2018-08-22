//
//  DateFormatter.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation

// Easy date formatting to use often
extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
