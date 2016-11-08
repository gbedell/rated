//
//  CreateRatingMoreInfoViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/18/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
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
