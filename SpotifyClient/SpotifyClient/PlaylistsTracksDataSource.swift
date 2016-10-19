//
//  PlaylistsTracksDataSource.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/17/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation
import Alamofire

/**
 This class manages a set of tracks belonging to a playlist.
 */
final class PlaylistsTracksDataSource {
    
    // TODO: implement pagination
    
    private var auth: SpotifyAuth {
        return SpotifyAuth.shared
    }
    
    let playlist: Playlist
    
    fileprivate(set) var tracks: [Track] = []
    
    // MARK: - Lifecycle
    
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    // MARK: -
    
    func fetchTracks(completion: ((_ tracks: [Track]?) -> Void)? = nil) {
        guard let session = auth.session else {
            completion?(nil)
            return
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let endpoint = SpotifyEndpoint.playlistTracks(ownerID: playlist.owner, playlistID: playlist.id)
        let request = Alamofire.request(endpoint.urlString, headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments), let dictionary = json as? [String: Any] {
                if let items = dictionary["items"] as? [[String: Any]] {
                    let tracks: [Track] = items.flatMap {
                        guard let trackDictionary = $0["track"] as? [String: Any] else { return nil }
                        return Track(dictionary: trackDictionary)
                    }
                    self.tracks = tracks
                    completion?(tracks)
                } else {
                    completion?(nil)
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    func addTracks(tracks: [Track], completion: ((_ snapshotID: String?) -> Void)? = nil) {
        guard let session = auth.session else {
            completion?(nil)
            return
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let endpoint = SpotifyEndpoint.addTrackToPlaylist(userID: playlist.owner, playlistID: playlist.id)
        
        let tracksUri = tracks.map({ "spotify:track:\($0.id)" })
        let parameters = ["uris": tracksUri]
        
        let request = Alamofire.request(endpoint.urlString,
                                        method: .post,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments), let dictionary = json as? [String: Any] {
                completion?(dictionary["snapshot_id"] as? String)
            } else {
                completion?(nil)
            }
        }
    }
    
}
