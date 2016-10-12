//
//  FollowedRatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/29/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class UserProfileViewController: RatingsViewController {
    
    var currentUser: Rater?

    var username: String? {
        didSet {
            self.title = username
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == controllerConstants.CREATE_RATING_SEGUE {
            var destinationVC = segue.destination
            if let navcon = destinationVC as? UINavigationController {
                destinationVC = navcon.visibleViewController ?? destinationVC
            }
            if let createRatingVC = destinationVC as? CreateRatingViewController {
                createRatingVC.rater = self.rater
            }
        }
    }
    
}
