//
//  CreateRatingMoreInfoViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/18/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateRatingDetailsViewController: UIViewController, UITextViewDelegate {
    
    var rater: Rater?
    var rating: Rating?
    
    @IBOutlet weak var ratingReviewTextView: UITextView!
    @IBOutlet weak var addPictureButton: UIButton!
    
    override func viewDidLoad() {
        ratingReviewTextView.delegate = self
        ratingReviewTextView.layer.borderWidth = 0.5
        ratingReviewTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        ratingReviewTextView.text = "Leave a review!"
        ratingReviewTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func createRating(_ sender: UIBarButtonItem) {
        // Call REST API for Creating Rating
        if let existingRater = self.rater,
            let rating = rating {
            let ratingName = rating.name
            let ratingScore = rating.score
            let raterId = existingRater.raterId!
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
    
    fileprivate struct controllerConstants {
        static let CREATE_RATING_URL = "https://ratedrest.herokuapp.com/ratings"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Leave a review!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    

}
