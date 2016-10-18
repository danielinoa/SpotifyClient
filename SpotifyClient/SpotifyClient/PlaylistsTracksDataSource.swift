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
                    let tracks = items.flatMap({ Track(dictionary: $0) })
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
    
}
