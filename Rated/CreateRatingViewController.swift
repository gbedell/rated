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
    @IBAction func ratingScoreChange(_ sender: UISlider) {
        ratingScoreLabel.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func dismissModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createRating(_ sender: UIBarButtonItem) {
        // Call REST API for Creating Rating
        if let existingRater = self.rater {
            let ratingName = ratingNameTextField.text!
            print("RATING NAME: \(ratingName)")
            let ratingScore = roundToPlaces(Double(ratingSlider.value), decimalPlaces: 1)
            print("RATING SCORE: \(ratingScore)")
            let raterId = existingRater.raterId!
            print("Rater Id: \(raterId)")
            let params: Parameters = [
                "name": ratingName,
                "score" :ratingScore,
                "rater" : [
                    "raterId" : raterId
                ]
            ]
            print("Params == \(params)")
            // Call Rest API
                
            // Basic Auth
            let user = "admin"
            let password = "899e42fc-8807-442e-8c7b-dc561f0f194a"
            
            var headers: HTTPHeaders = [:]
            
            if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            Alamofire.request(controllerConstants.CREATE_RATING_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let data):
                            print(data)
                            let json = JSON(data)
                            print(json)
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        }
                }
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        createRatingButton.isEnabled = false
    }
    
    @IBAction func checkEnableCreateButton(_ sender: UITextField) {
        if (sender.text?.characters.count)! > 0 {
            createRatingButton.isEnabled = true
        } else {
            createRatingButton.isEnabled = false
        }
    }
    
    fileprivate func roundToPlaces(_ value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    fileprivate struct controllerConstants {
        static let CREATE_RATING_URL = "https://ratedrest.herokuapp.com/ratings"
    }
    
    
    
}
