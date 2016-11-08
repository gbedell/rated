//
//  Rater.swift
//  Rated
//
//  Created by Gavin Bedell on 9/17/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import Foundation
import FirebaseAuth

open class Rater {
    
    var uid: String?
    var displayName: String?
    var username: String?
    var email: String?
    var photoUrl: String?
    var dateCreated: Date?
    var lastLogin: Date?
    var isFirstLogin: Bool?
    
    init(uid: String, displayName: String, username: String, email: String) {
        self.uid = uid
        self.displayName = displayName
        self.username = username
        self.email = email
    }
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email
    }
    
}
