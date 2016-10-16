//
//  LoginViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    /**
     Opens browser with authentication url.
     */
    @IBAction func signInAction(_ sender: AnyObject) {
        let url = SpotifyAuth.shared.authenticationURL
        UIApplication.shared.open(url, options: [:]) { _ in }
    }
    
}
