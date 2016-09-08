//
//  Rating+CoreDataProperties.swift
//  Rated
//
//  Created by Gavin Bedell on 9/7/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Rating {

    @NSManaged var name: String?
    @NSManaged var score: NSNumber?

}
