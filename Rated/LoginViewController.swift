//
//  LoginViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/7/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // Mark - Model
    var rater: Rater? 
    
    // Mark - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("Access token wasnt nil")
        } else {
            let loginButton: FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginButton)
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            returnUserData()
        }
    }
    
    // Mark - FBSDKLoginButtonDelegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User logged in")
        
        if((error) != nil) {
            print("Hey, there's been an error")
        }
        else if result.isCancelled {
            print("Hey, the login has been cancelled")
        }
        else {
            if result.grantedPermissions.contains("email") {
                print("I guess this permission was granted?")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    // Mark - Private Methods
    private struct loginViewConstants {
        static let LOGIN_SUCCESS_SEGUE = "LoginSuccess"
        static let GET_USER_INFO_URL = "http://localhost:8080/raters/find-by-fb/"
    }
    
    private func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                let json = JSON(result)
                let fbId = json["id"].intValue
                self.getUserInfo(fbId)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loginViewConstants.LOGIN_SUCCESS_SEGUE {
            var destinationVC = segue.destinationViewController
            if let navcon = destinationVC as? UINavigationController {
                destinationVC = navcon.visibleViewController ?? destinationVC
            }
            if let ratingsTableVC = destinationVC as? RatingsTableViewController {
                ratingsTableVC.rater = self.rater
            }
        }
    }
    
    private func getUserInfo(facebookId: Int) {
        Alamofire.request(.GET, loginViewConstants.GET_USER_INFO_URL + String(facebookId))
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    print(data)
                    let json = JSON(data)
                    let username = json["username"].stringValue
                    let email = json["email"].stringValue
                    let userId = json["userId"].intValue
                    let facebookId = json["facebookId"].intValue
                    
                    let user = Rater()
                    
                    user.username = username
                    user.email = email
                    user.raterId = userId
                    user.facebookId = facebookId
                    
                    self.rater = user
                    
                    self.performSegueWithIdentifier(loginViewConstants.LOGIN_SUCCESS_SEGUE, sender: self)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
            }
        
    }
    
}
