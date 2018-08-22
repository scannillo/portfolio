//
//  Users.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/28/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//
import Foundation

// These two classes are used as structures/objects to house information from the database in-app

class Musicians {
    var users : [Users] = [Users]()
}

class Users {
    var id : String = ""
    var bio : String = ""
    var email : String = ""
    var musicianName : String = ""
    var profileImage : String = ""
    var filePath : String = ""
    var website : String = ""
    var description : String = ""
    var songID : String = ""
    
}

