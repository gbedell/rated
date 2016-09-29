//
//  LoginViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/7/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import Alamofire
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
        } else {
            print("No access token")
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
                
                // Basic Auth
                let user = "admin"
                let password = "899e42fc-8807-442e-8c7b-dc561f0f194a"
                
                var headers: HTTPHeaders = [:]
                
                if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                    headers[authorizationHeader.key] = authorizationHeader.value
                }
                
                Alamofire.request(controllerConstants.GET_USER_INFO_URL + String(facebookId), headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let data):
                            print(data)
                            let json = JSON(data)
                            let username = json["username"].stringValue
                            let email = json["email"].stringValue
                            let raterId = json["raterId"].intValue
                            let facebookId = json["facebookId"].intValue
                            
                            let user = Rater()
                            
                            user.username = username
                            user.email = email
                            user.raterId = raterId
                            user.facebookId = facebookId
                            
                            self.rater = user
                            
                            self.performSegue(withIdentifier: controllerConstants.LOGIN_SUCCESS_SEGUE, sender: self)
                            
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == controllerConstants.LOGIN_SUCCESS_SEGUE {
            var destinationVC = segue.destination
            if let navcon = destinationVC as? UINavigationController {
                destinationVC = navcon.visibleViewController ?? destinationVC
            }
            if let ratingsTableVC = destinationVC as? RatingsTableViewController {
                ratingsTableVC.rater = self.rater
            }
        }
    }
    
}
