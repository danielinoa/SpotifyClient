//
//  NavigationViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController, SpotifyAuthDelegate {

    // MARK: - Lifecycle
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewControllers = [rootViewController]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View Controllers
    
    private var rootViewController: UIViewController {
        return SpotifyAuth.shared.isAuthenticated ? PlaylistsViewController() : LoginViewController()
    }
    
    // MARK: - SpotifyAuthDelegate
    
    func sessionUpdated(in spotifyAuth: SpotifyAuth) {
        setViewControllers([rootViewController], animated: false)
    }
    
}
