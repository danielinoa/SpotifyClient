//
//  AppDelegate.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/14/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var auth: SpotifyAuth {
        return SpotifyAuth.shared
    }
    
    private let navigationController = NavigationViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        auth.delegate = navigationController
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        auth.handle(authenticationUrl: url)
        auth.fetchAccessToken()
        return true
    }
    
}
