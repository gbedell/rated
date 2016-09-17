//
//  RatingsTableViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/4/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RatingsTableViewController: CoreDataTableViewController {
        
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
        didSet { updateUI() }
    }
    
    var userEmail: String?
    
    private struct uiConstants {
        static let CREATE_RATING_SEGUE = "CreateRating"
        static let VIEW_RATING_SEGUE = "ViewRating"
    }
    
    func updateUI() {
        if let context = managedObjectContext {
            let request = NSFetchRequest(entityName: "Rating")
            request.sortDescriptors = [NSSortDescriptor(key: "score", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RatingTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RatingCell", forIndexPath: indexPath) as! RatingTableViewCell
        
        if let rating = fetchedResultsController?.objectAtIndexPath(indexPath) as? Rating {
            var ratingName: String?
            var ratingScore: NSNumber?
            rating.managedObjectContext?.performBlockAndWait {
                ratingName = rating.name
                ratingScore = rating.score
            }
            cell.ratingName.text = ratingName
            print(ratingScore!)
            cell.ratingScore.text = String(ratingScore!)
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test Rating
        let newRating = NSEntityDescription.insertNewObjectForEntityForName("Rating", inManagedObjectContext: managedObjectContext!) as! Rating
        newRating.name = "Arizona Green Tea"
        newRating.score = 8.8
        
        Alamofire.request(.GET, "http://localhost:8080/raters/find-by-fb/" + String(588445801310406))
            .responseJSON { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        updateUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == uiConstants.CREATE_RATING_SEGUE {
            var destinationVC = segue.destinationViewController
            if let navcon = destinationVC as? UINavigationController {
                destinationVC = navcon.visibleViewController ?? destinationVC
            }
            if let createRatingVC = destinationVC as? CreateRatingViewController {
                createRatingVC.managedObjectContext = self.managedObjectContext
            }
        } else if segue.identifier == uiConstants.VIEW_RATING_SEGUE {
            if let destinationVC = segue.destinationViewController as? RatingViewController {
                let cell = sender as! RatingTableViewCell
                let ratingName = cell.ratingName.text
                let ratingScore = cell.ratingScore.text
                
                destinationVC.ratingName = ratingName
                destinationVC.ratingScore = ratingScore
                
            }
        }
    }
    
    

}
