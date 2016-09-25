//
//  RatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/4/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RatingsTableViewController: UITableViewController {
    
    // Mark - Model
    var rater: Rater?
    
    var ratings = Array<Rating>() {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        // Fetch user's ratings
        getUserRatings()
    }
        
    private struct uiConstants {
        static let CREATE_RATING_SEGUE = "CreateRating"
        static let VIEW_RATING_SEGUE = "ViewRating"
        static let GET_USER_RATINGS_URL = "http://localhost:8080/ratings/find-by-rater/"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RatingTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingTableViewCell
        let rating = self.ratings[indexPath.row]
        cell.rating = rating
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == uiConstants.CREATE_RATING_SEGUE {
            var destinationVC = segue.destination
            if let navcon = destinationVC as? UINavigationController {
                destinationVC = navcon.visibleViewController ?? destinationVC
            }
            if let createRatingVC = destinationVC as? CreateRatingViewController {
                createRatingVC.rater = self.rater
            }
        } else if segue.identifier == uiConstants.VIEW_RATING_SEGUE {
            if let destinationVC = segue.destination as? RatingViewController {
                let cell = sender as! RatingTableViewCell
                let ratingName = cell.ratingName.text
                let ratingScore = cell.ratingScore.text
                
                destinationVC.ratingName = ratingName
                destinationVC.ratingScore = ratingScore
                
            }
        }
    }
    
    private func getUserRatings() {
        // Call REST API to get User Ratings
        if let raterId = rater?.raterId {
            Alamofire.request(uiConstants.GET_USER_RATINGS_URL + String(raterId))
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        let json = JSON(data)
                        if let ratingsArray = json.array {
                            for r in ratingsArray {
                                let rating = Rating()
                                rating.ratingId = r["ratingId"].intValue
                                rating.name = r["name"].stringValue
                                rating.score = r["score"].doubleValue
                                rating.raterId = r["rater"]["userId"].intValue
                                self.ratings.append(rating)
                            }
                        }
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
            }
        }
    }
    
    

}
