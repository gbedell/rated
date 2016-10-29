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
    var username: String?
    var email: String?
    var dateCreated: Date?
    
    init(uid: String, username: String, email: String, dateCreated: Date) {
        self.uid = uid
        self.username = username
        self.email = email
        self.dateCreated = dateCreated
    }
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email
    }
    
}
