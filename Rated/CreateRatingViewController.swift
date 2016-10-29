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
    @IBOutlet weak var goToMoreDetailsButton: UIBarButtonItem!

    
    // Mark: Actions
    @IBAction func ratingScoreChange(_ sender: UISlider) {
        ratingScoreLabel.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func dismissModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        goToMoreDetailsButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ratingNameTextField.becomeFirstResponder()
    }
    
    @IBAction func checkEnableCreateButton(_ sender: UITextField) {
        if (sender.text?.characters.count)! > 0 {
            goToMoreDetailsButton.isEnabled = true
        } else {
            goToMoreDetailsButton.isEnabled = false
        }
    }
    
    fileprivate func roundToPlaces(_ value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    fileprivate struct controllerConstants {
        static let CREATE_RATING_URL = "https://ratedrest.herokuapp.com/ratings"
        static let MORE_DETAILS_SEGUE = "toCreateRatingsDetails"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == controllerConstants.MORE_DETAILS_SEGUE {
            if let destinationVC = segue.destination as? CreateRatingDetailsViewController,
                let rater = rater {
                destinationVC.rater = rater
                
                let rating = Rating()
                rating.name = ratingNameTextField.text
                rating.score = roundToPlaces(Double(ratingSlider.value), decimalPlaces: 1)
                
            }
        }
    }
    
    
    
}
