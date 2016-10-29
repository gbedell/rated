//
//  Rating.swift
//  Rated
//
//  Created by Gavin Bedell on 9/17/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import Foundation
import Firebase

open class Rating {
    
    var key: String?
    var name: String?
    var score: Double?
    var dateCreated: Date?
    var rater: String?
    
    let ref: FIRDatabaseReference?
    
    init(key: String, name: String, score: Double, rater: String, dateCreated: Date) {
        self.key = key
        self.name = name
        self.score = score
        self.dateCreated = dateCreated
        self.rater = rater
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = (snapshotValue["name"] as! String)
        score = (snapshotValue["score"] as! Double)
        dateCreated = (snapshotValue["dateCreated"] as! Date)
        rater = (snapshotValue["rater"] as! String)
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
        "name": name,
        "score": score,
        "dateCreated": dateCreated,
        "rater": rater
        ]
    }
    
}
