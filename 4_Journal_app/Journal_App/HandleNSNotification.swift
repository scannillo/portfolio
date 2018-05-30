//
//  HandleNSNotification.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/25/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let noLocalData = Notification.Name(
        rawValue: "noLocalData")
    
    static let finishedSyncing = Notification.Name(
        rawValue: "finishedSyncing")
    
    static let finishedPostingEditToCloud = Notification.Name(
        rawValue: "finishedPostingEditToCloud")
    
    static let photoSavedToCloud = Notification.Name(
        rawValue: "photoSavedToCloud")
    
    static let errorSaving = Notification.Name(
        rawValue: "errorSaving")

}
