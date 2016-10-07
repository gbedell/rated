//
//  RatingsViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/6/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RatingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //============================================
    // Model
    //============================================
    
    var rater: Rater?
    
    var ratings = Array<Rating>() {
        didSet { tableView.reloadData() }
    }
    
    var ratingsUrl: String?
    
    //============================================
    // IB Outlets
    //============================================
    
    @IBOutlet weak var tableView: UITableView!
    
    //============================================
    // Tableview Methods
    //============================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingTableViewCell
        let rating = self.ratings[indexPath.row]
        cell.rating = rating
        return cell
    }
    
    //============================================
    // Lifecycle Methods
    //============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Fetch Ratings
        fetchRatings()
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //============================================
    // IB Actions
    //============================================
    
    @IBAction func createRating(_ sender: UIButton) {
        
    }
    
    //============================================
    // Public Functions
    //============================================
    func handleRefresh(refreshControl: UIRefreshControl) {
        ratings.removeAll()
        fetchRatings()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //============================================
    // Private Functions
    //============================================
    private func fetchRatings() {
        // Basic Auth
        let user = "admin"
        let password = "899e42fc-8807-442e-8c7b-dc561f0f194a"
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        if let ratingsUrl = ratingsUrl {
            Alamofire.request(ratingsUrl, headers: headers)
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
                                let transformedRater = Rater()
                                transformedRater.raterId = r["rater"]["raterId"].intValue
                                transformedRater.facebookId = r["rater"]["facebookId"].intValue
                                transformedRater.username = r["rater"]["username"].stringValue
                                transformedRater.email = r["rater"]["email"].stringValue
                                // Do something with date here eventually
                                
                                // Add Rater to Rating
                                rating.rater = transformedRater
                                
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
