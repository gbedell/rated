//
//  FollowedRatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/29/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class UserRatingsTableViewController: RatingsTableViewController {

    var username: String? {
        didSet {
            self.title = username
        }
    }
    
}
