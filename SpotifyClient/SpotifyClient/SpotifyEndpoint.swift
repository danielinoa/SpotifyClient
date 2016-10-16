//
//  SpotifyEndpoint.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation

/**
 This enum describes the different Spotify endpoints.
 */
enum SpotifyEndpoint: String {
    
    // MARK: - Authentication
    
    case authentication = "https://accounts.spotify.com/authorize"
    case token = "https://accounts.spotify.com/api/token"
    
    // MARK: - API
    
    case apiBase = "https://api.spotify.com"
    case me = "https://api.spotify.com/v1/me"
    
    // MARK: -
    
    /**
     Endpoint url string representation.
     */
    var urlString: String {
        return self.rawValue
    }
    
}
