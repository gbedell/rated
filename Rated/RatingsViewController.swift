//
//  RatingsViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/6/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
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
    
    struct controllerConstants {
        static let CREATE_RATING_SEGUE = "toCreateRatingView"
        static let VIEW_RATING_SEGUE = "toViewRatingView"
        static let TO_USER_RATINGS_TABLE_SEGUE = "toUserRatingsTable"
        static let GET_USER_RATINGS_URL = "https://ratedrest.herokuapp.com/ratings/rater/"
        static let GET_USER_RATINGS_BY_USERNAME_URL = "https://ratedrest.herokuapp.com/ratings/rater/username/"
    }
    
    private func fetchRatings() {}

}
