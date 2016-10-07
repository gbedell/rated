//
//  RatingTableViewCell.swift
//  Rated
//
//  Created by Gavin Bedell on 9/5/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    
    var rating: Rating? { didSet { updateUI() } }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameButton: UIButton!
    
    @IBOutlet weak var ratingScoreLabel: UILabel!
    
    @IBOutlet weak var ratingNameLabel: UILabel!
    
    @IBOutlet weak var ratingReviewLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    fileprivate func updateUI() {
        // Reset any UI information
        userImageView.image = nil
        usernameButton.setTitle(nil, for: .normal)
        ratingScoreLabel.text = nil
        ratingNameLabel.text = nil
        //ratingReviewLabel.text = nil
        //ratingImageView.image = nil
        
        // Load new information, if any
        if let rating = self.rating {
            if let ratingName = rating.name,
                let ratingScore = rating.score,
                let rater = rating.rater {
                if let username = rater.username {
                    ratingScoreLabel.text = String(ratingScore)
                    ratingNameLabel.text = ratingName
                    usernameButton.setTitle(username, for: .normal)
                }
                
            }
        }
        
    }

}
