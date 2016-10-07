//
//  FollowedRatingsViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/6/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class FollowedRatingsViewController: RatingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rated"
    }
    
    private struct controllerConstants {
        static let CREATE_RATING_SEGUE = "toCreateRatingView"
        static let VIEW_RATING_SEGUE = "toViewRatingView"
        static let TO_USER_RATINGS_TABLE_SEGUE = "toUserRatingsTable"
        static let GET_USER_RATINGS_URL = "https://ratedrest.herokuapp.com/ratings/rater/"
        static let GET_USER_RATINGS_BY_USERNAME_URL = "https://ratedrest.herokuapp.com/ratings/rater/username/"
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
        } else if segue.identifier == controllerConstants.VIEW_RATING_SEGUE {
            if let destinationVC = segue.destination as? RatingViewController {
                let cell = sender as! RatingTableViewCell
                let ratingName = cell.ratingNameLabel.text
                let ratingScore = cell.ratingScoreLabel.text
                
                destinationVC.ratingName = ratingName
                destinationVC.ratingScore = ratingScore
                
            }
        } else if segue.identifier == controllerConstants.TO_USER_RATINGS_TABLE_SEGUE {
            if let destinationVC = segue.destination as? UserProfileViewController {
                let usernameButton = sender as! UIButton
                let username = usernameButton.currentTitle
                
                let ratingsUrl = controllerConstants.GET_USER_RATINGS_BY_USERNAME_URL + username!
                
                destinationVC.ratingsUrl = ratingsUrl
                destinationVC.username = username
            }
        }
    }

}
