//
//  CreateRatingViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/4/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
        if let existingRater = self.rater {
            if let ratingName = ratingNameTextField.text {
                let ratingScore = roundToPlaces(Double(ratingSlider.value), decimalPlaces: 1)
                let raterId = existingRater.raterId
                let facebookId = existingRater.facebookId
                let raterParams: [String: AnyObject] = [
                    "userId": raterId!,
                    "facebookId": facebookId!
                ]
                let params: [String: AnyObject] = [
                    "name"  : ratingName,
                    "score" : ratingScore,
                    "rater" : raterParams
                ]
                print("Parameters: \(params)")
                // Call Rest API
                Alamofire.request(.POST, uiConstants.CREATE_RATING_URL, parameters: params, encoding: .JSON, headers: nil)
                    .responseJSON { response in
                        switch response.result {
                        case .Success(let data):
                            print(data)
                            let json = JSON(data)
                            print(json)
                        case .Failure(let error):
                            print("Request failed with error: \(error)")
                        }
                }
            }
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
    
    private struct uiConstants {
        static let CREATE_RATING_URL = "http://localhost:8080/ratings"
    }
    
    
    
}
