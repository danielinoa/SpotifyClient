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
enum SpotifyEndpoint {
    
    // MARK: - Cases
    
    /**
     Endpoint to request an authorization.
     */
    case authentication
    
    /**
     Endpoint to retrieve access and refresh tokens.
     */
    case token

    /**
     Endpoint to retrieve detailed profile information about the current user.
     */
    case me
    
    /**
     Endpoint to retrieve playlists owned or followed by the current Spotify user.
     */
    case playlists
    
    /**
     Endpoint to create a playlist for a Spotify user.
     */
    case createPlaylist(userID: String)
    
    /**
     Endpoint to add one or more tracks to a user's playlist
     */
    case addTrackToPlaylist(userID: String, playlistID: String)
    
    /**
     Endpoint to modify a playlist’s name and public/private state.
     */
    case updatePlaylist(userID: String, playlistID: String)
    
    /**
     Endpoint to remove one or more tracks from a user’s playlist.
     */
    case deleteTrackFromPlaylist(userID: String, playlistID: String)
    
    /**
     Endpoint to retrieve full details of the tracks of a playlist owned by a Spotify user.
     */
    case playlistTracks(ownerID: String, playlistID: String)
    
    /**
     Endpoint to retrieve catalog information about artists, albums, tracks or playlists that match a keyword string.
     */
    case search
    
    // MARK: - URL
    
    /**
     Endpoint url string representation.
     */
    var urlString: String {
        let urlString: String
        switch self {
            case .authentication: urlString = "https://accounts.spotify.com/authorize"
            case .token: urlString = "https://accounts.spotify.com/api/token"
            case .me: urlString = "https://api.spotify.com/v1/me"
            case .playlists: urlString = "https://api.spotify.com/v1/me/playlists"
            case .createPlaylist(let userID): urlString = "https://api.spotify.com/v1/users/\(userID)/playlists"
            case .updatePlaylist(let userID, let playlistID): urlString = "https://api.spotify.com/v1/users/\(userID)/playlists/\(playlistID)"
            case .addTrackToPlaylist(let userID, let playlistID): urlString = "https://api.spotify.com/v1/users/\(userID)/playlists/\(playlistID)/tracks"
            case .deleteTrackFromPlaylist(let userID, let playlistID): urlString = "https://api.spotify.com/v1/users/\(userID)/playlists/\(playlistID)/tracks"
            case .playlistTracks(let ownerID, let playlistID): urlString = "https://api.spotify.com/v1/users/\(ownerID)/playlists/\(playlistID)/tracks"
            case .search: urlString = "https://api.spotify.com/v1/search"
        }
        return urlString
    }
    
}
