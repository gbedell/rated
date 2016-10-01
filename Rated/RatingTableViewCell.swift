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
    
    @IBOutlet weak var ratingScore: UILabel!
    
    @IBOutlet weak var ratingName: UILabel!
    
    @IBOutlet weak var usernameButton: UIButton!
    
    
    fileprivate func updateUI() {
        // Reset any UI information
        self.ratingName.text = nil
        self.ratingScore.text = nil
        self.usernameButton.setTitle(nil, for: .normal)
        
        // Load new information, if any
        if let rating = self.rating {
            if let ratingName = rating.name,
                let ratingScore = rating.score,
                let rater = rating.rater {
                if let username = rater.username {
                    self.ratingName.text = ratingName
                    self.ratingScore.text = String(ratingScore)
                    self.usernameButton.setTitle(username, for: .normal)
                }
                
            }
        }
        
    }

}
