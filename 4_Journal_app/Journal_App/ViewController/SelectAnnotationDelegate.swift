//
//  SelectAnnotationDelegate.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/30/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation

protocol SelectAnnotationDelegate: class {
    
    func sendAnnotationToMainVC(filteredLat: Double, filteredLong: Double) -> Void
    
}
