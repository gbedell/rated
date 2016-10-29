//
//  LoginViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/7/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import SwiftyJSON
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    // Mark - Model
    var rater: Rater?
    
    var accessToken: AccessToken?
    
    // Mark - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current {
            print("User has a current access token: \(accessToken)")
            self.accessToken = accessToken
        } else {
            print("No current access token")
            let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
            loginButton.center = view.center
            loginButton.delegate = self
            view.addSubview(loginButton)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = self.accessToken {
            print("Access token: \(accessToken)")
            returnUserData()
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .success:
            returnUserData()
        case .cancelled:
            print("User cancelled login.")
        case .failed(let error):
            print(error)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("User logged out.")
    }
    
    fileprivate struct controllerConstants {
        static let LOGIN_SUCCESS_SEGUE = "LoginSuccess"
        static let GET_USER_INFO_URL = "https://ratedrest.herokuapp.com/raters/facebook-id/"
        static let GET_FOLLOWED_RATINGS_URL = "https://ratedrest.herokuapp.com/ratings/follower-rater-id/"
    }
    
    fileprivate func returnUserData() {
        
        let params = ["fields" : "email"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params, accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                print("Error with graph request: \(error).")
            case .success(let graphResponse):
                let resultJson = JSON(graphResponse.dictionaryValue)
                
                let facebookId = resultJson["id"].intValue
                print("FacebookId = \(facebookId)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == controllerConstants.LOGIN_SUCCESS_SEGUE {
            var destinationVC = segue.destination
            if let navcon = destinationVC as? UINavigationController {
                destinationVC = navcon.visibleViewController ?? destinationVC
            }
            if let ratingsTableVC = destinationVC as? FollowedRatingsViewController {
                if let rater = self.rater {
                    ratingsTableVC.rater = rater
                    //ratingsTableVC.ratingsUrl = controllerConstants.GET_FOLLOWED_RATINGS_URL + String(rater.raterId!)
                }
            }
        }
    }
    
}
