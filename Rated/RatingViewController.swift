//
//  RatingViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/5/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    var ratingName:String?
    var ratingScore:String?
    
    // Mark - Outlets
    @IBOutlet weak var ratingScoreLabel: UILabel! { didSet { ratingScoreLabel.text = ratingScore } }
    @IBOutlet weak var ratingNameLabel: UILabel! { didSet { ratingNameLabel.text = ratingName } }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

}
