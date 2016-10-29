//
//  RatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/28/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RatingsTableViewController: UITableViewController {
    
    // Mark: - Model
    
    var ratings: [Rating] = []
    
    let ref = FIRDatabase.database().reference(withPath: "ratings")
    let ratingCell = "RatingCell"
    
    struct controllerConstants {
        static let CREATE_RATING_SEGUE = "toCreateRatingView"
        static let VIEW_RATING_SEGUE = "toViewRatingView"
        static let TO_USER_RATINGS_TABLE_SEGUE = "toUserRatingsTable"
    }
    
    // Mark: - Lifecycle methods

    override func viewDidLoad() {
        title = "Rated"
        
        // Watch for changes in ratings from firebase
        ref.observe(.value, with: { snapshot in
            
            var newRatings: [Rating] = []
            for rating in snapshot.children {
                let r = Rating(snapshot: rating as! FIRDataSnapshot)
                newRatings.append(r)
            }
            
            self.ratings = newRatings
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ratingCell, for: indexPath) as! RatingTableViewCell
        let rating = ratings[indexPath.row]
        cell.rating = rating
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let rating = ratings[indexPath.row]
            rating.ref?.removeValue()
        }
    }

    // Mark: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == controllerConstants.CREATE_RATING_SEGUE {
//            var destinationVC = segue.destination
//            if let navcon = destinationVC as? UINavigationController {
//                destinationVC = navcon.visibleViewController ?? destinationVC
//            }
//            if let createRatingVC = destinationVC as? CreateRatingViewController {
//                // createRatingVC.rater = self.rater
//            }
//        } else if segue.identifier == controllerConstants.VIEW_RATING_SEGUE {
//            if let destinationVC = segue.destination as? RatingViewController {
//                let cell = sender as! RatingTableViewCell
//                let ratingName = cell.ratingNameLabel.text
//                let ratingScore = cell.ratingScoreLabel.text
//                
//                destinationVC.ratingName = ratingName
//                destinationVC.ratingScore = ratingScore
//                
//            }
//        } else if segue.identifier == controllerConstants.TO_USER_RATINGS_TABLE_SEGUE {
//            if let destinationVC = segue.destination as? UserProfileViewController,
//                // let rater = rater {
//                let usernameButton = sender as! UIButton
//                let username = usernameButton.currentTitle
//                
//                // let ratingsUrl = controllerConstants.GET_USER_RATINGS_BY_USERNAME_URL + username!
//                
//                destinationVC.ratingsUrl = ratingsUrl
//                destinationVC.username = username
//                destinationVC.rater = rater
//                
//            }
//        }
//    }

    
}
