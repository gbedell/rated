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
    
    private func updateUI() {
        
        // Reset any UI information
        self.ratingName.text = nil
        self.ratingScore.text = nil
        
        // Load new information, if any
        if let rating = self.rating {
            self.ratingName.text = rating.name
            self.ratingScore.text = String(rating.score)
        }
        
    }

}
