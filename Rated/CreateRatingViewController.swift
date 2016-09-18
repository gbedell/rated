//
//  CreateRatingViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/4/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit

class CreateRatingViewController: UIViewController {
    
    var rater: Rater?
    
    // Mark: Outlets
    @IBOutlet weak var ratingNameTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingScoreLabel: UILabel!
    @IBOutlet weak var createRatingButton: UIBarButtonItem!

    
    // Mark: Actions
    @IBAction func ratingScoreChange(sender: UISlider) {
        ratingScoreLabel.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func dismissModal(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createRating(sender: UIBarButtonItem) {
        // Call REST API for Creating Rating
        if let raterId = self.rater?.raterId {
            let newRating = RatingRestForm()
            newRating.name = ratingNameTextField.text
            newRating.score = roundToPlaces(Double(ratingSlider.value), decimalPlaces: 1)
            newRating.rater?.raterId = raterId
            // Call REST API
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        createRatingButton.enabled = false
    }
    
    @IBAction func checkEnableCreateButton(sender: UITextField) {
        if sender.text?.characters.count > 0 {
            createRatingButton.enabled = true
        } else {
            createRatingButton.enabled = false
        }
    }
    
    private func roundToPlaces(value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    
    
}
