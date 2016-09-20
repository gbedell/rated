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
    
    fileprivate func updateUI() {
        // Reset any UI information
        self.ratingName.text = nil
        self.ratingScore.text = nil
        
        // Load new information, if any
        if let rating = self.rating {
            if let ratingName = rating.name, let ratingScore = rating.score {
                self.ratingName.text = ratingName
                self.ratingScore.text = String(ratingScore)
            }
        }
        
    }

}
