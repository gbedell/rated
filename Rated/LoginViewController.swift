//
//  LoginViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/7/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // Mark - Model
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

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
            print(returnUserData())
            self.performSegueWithIdentifier(loginViewConstants.LOGIN_SUCCESS_SEGUE, sender: self)
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
            //Create new user here?
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
    }
    
    private func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                if let userName : NSString = result.valueForKey("name") as? NSString {
                    print("User Name is: \(userName)")
                }
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    print("User Email is: \(userEmail)")
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loginViewConstants.LOGIN_SUCCESS_SEGUE {
            
            // Pass user information to the rating table view controller
            
        }
    }
    
}
