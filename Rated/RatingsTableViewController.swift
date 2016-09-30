//
//  RatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/29/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RatingsTableViewController: UITableViewController {
    
    // Mark: - Model
    var rater: Rater?
    
    var ratings = Array<Rating>() {
        didSet { tableView.reloadData() }
    }
    
    var tableRatingsType: String? {
        didSet {
            if let rater = rater {
                if let raterId = rater.raterId
                switch tableRatingsType {
                case "user":
                    ratingsUrl = "https://ratedrest.herokuapp.com/ratings/rater/" + String(raterId)
                case "followed":
                    ratingsUrl = "https://ratedrest.herokuapp.com/ratings/follower-rater-id/" + String(raterId)"
                case "rating":
                    ratingsUrl = "Rating's ratings URL"
                }
            }
            
        }
    }
    
    var ratingsUrl: String?
    
    // Mark: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RatingTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingTableViewCell
        let rating = self.ratings[indexPath.row]
        cell.rating = rating
        return cell
    }
    
    // Mark: - Lifecycle Methods
    override func viewDidLoad() {
        // Fetch Ratings
        fetchRatings()
        
        // Refresh Control
        refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    // Mark: - Private Functions
    private func handleRefresh(refreshControl: UIRefreshControl) {
        ratings.removeAll()
        fetchRatings()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func fetchRatings() {
        
        if let existingRater = rater {
            if let raterId = existingRater.raterId {
                
                // Basic Auth
                let user = "admin"
                let password = "899e42fc-8807-442e-8c7b-dc561f0f194a"
                var headers: HTTPHeaders = [:]
                if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                    headers[authorizationHeader.key] = authorizationHeader.value
                }
                
                if let ratingsUrl = ratingsUrl {
                    
                    Alamofire.request(path, headers: headers)
                        .responseJSON { response in
                            switch response.result {
                            case .success(let data):
                                print(data)
                                let json = JSON(data)
                                if let ratingsArray = json.array {
                                    for r in ratingsArray {
                                        // Parse JSON into Rating object
                                        let rating = Rating()
                                        rating.ratingId = r["ratingId"].intValue
                                        rating.name = r["name"].stringValue
                                        rating.score = r["score"].doubleValue
                                        
                                        // Parse JSON into Rater object
                                        let existingRater = Rater()
                                        existingRater.raterId = r["rater"]["raterId"].intValue
                                        existingRater.facebookId = r["rater"]["facebookId"].intValue
                                        existingRater.username = r["rater"]["username"].stringValue
                                        existingRater.email = r["rater"]["email"].stringValue
                                        // Do something with date here eventually
                                        
                                        // Add Rater to Rating
                                        rating.rater = existingRater
                                        
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
        
        
}
