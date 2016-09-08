//
//  LoginViewController.swift
//  Rated
//
//  Created by Gavin Bedell on 9/7/16.
//  Copyright © 2016 Gavin Bedell. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [.PublicProfile])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }

}
