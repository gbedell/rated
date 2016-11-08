//
//  LoginViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 10/29/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // Mark: Properties
    
    var loginButton = FBSDKLoginButton()
    
    var firebaseRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // Mark: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.isHidden = true
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                let uid = user?.uid
                let existingUserRef = self.firebaseRef.child("users").child(uid!)
                existingUserRef.updateChildValues(["lastLogin": Date().timeIntervalSince1970])
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "InitialNavigation") as! UINavigationController
                
                self.present(navigationViewController, animated: true, completion: nil)
                
            } else {
                // No user is signed in, display the login button
                self.loginButton.frame = CGRect(x: 16, y: 100, width: self.view.frame.width - 32, height: 50)
                self.loginButton.delegate = self
                self.loginButton.readPermissions = ["email", "public_profile"]
                self.loginButton.isHidden = false
                
                self.view.addSubview(self.loginButton)
            }
        }
    }
    
    // Mark: Facebook Methods
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User successfully logged out of Facebook.")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        self.loginButton.isHidden = true
        
        self.activityIndicatorView.startAnimating()
        
        if error != nil {
            print(error)
            
            self.loginButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            
        } else if (result.isCancelled) {
            
            print("User cancelled Facebook Authentication")
            
            self.loginButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            
        } else {
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    print("Firebase Authentication failed with error:", error)
                } else {
                    print("Firebase Authentication successful")
                    
                    let userRef = self.firebaseRef.child("users")
                    let uid = user?.uid
                    let email = user?.email
                    let photoUrl = user?.photoURL?.absoluteString
                    let name = user?.displayName
                    
                    userRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        print(snapshot.value)
                        if !snapshot.exists() {
                            var newUser = [String: Any]()
                            newUser["uid"] = uid
                            newUser["displayName"] = name
                            newUser["email"] = email
                            newUser["photoUrl"] = photoUrl
                            newUser["isFirstLogin"] = true
                            newUser["lastLogin"] = NSDate().timeIntervalSince1970
                            newUser["dateCreated"] = NSDate().timeIntervalSince1970
                            
                            let newUserRef = userRef.child(uid!)
                            newUserRef.setValue(newUser)
                        }
                    })
                }
            }
        }
    }
    
}
