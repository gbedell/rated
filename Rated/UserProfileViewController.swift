//
//  FollowedRatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/29/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class UserProfileViewController: RatingsViewController {

    var username: String? {
        didSet {
            self.title = username
        }
    }
    
}
