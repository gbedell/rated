//
//  CreateRatingViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/4/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import CoreData

class CreateRatingViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
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
        if let ratingName = ratingNameTextField.text {
            let ratingScore = ratingSlider.value
            let newRating = NSEntityDescription.insertNewObjectForEntityForName("Rating", inManagedObjectContext: managedObjectContext!) as! Rating
            newRating.name = ratingName
            newRating.score = roundToPlaces(Double(ratingScore), decimalPlaces: 1)
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
