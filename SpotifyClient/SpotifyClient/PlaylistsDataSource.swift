//
//  PlaylistsDataSource.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation
import Alamofire

/**
 This class manages a set of playlists, and provides methods to create, fetch, and update them.
 */
final class PlaylistsDataSource {
    
    // TODO: implement pagination
    
    private var auth: SpotifyAuth {
        return SpotifyAuth.shared
    }
    
    fileprivate(set) var playlists: [Playlist] = []
    
    func fetchPlaylists(completion: ((_ playlists: [Playlist]?) -> Void)? = nil) {
        guard let session = auth.session else {
            // TODO: handle this
            fatalError()
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let request = Alamofire.request(SpotifyEndpoint.playlists.urlString, headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments), let dictionary = json as? [String: Any] {
                if let items = dictionary["items"] as? [[String: Any]] {
                    let playlists = items.flatMap({ Playlist(dictionary: $0) })
                    self.playlists = playlists
                    completion?(playlists)
                } else {
                    completion?(nil)
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    func createPlaylist(name: String, userID: String, completion: ((_ playlist: Playlist?) -> Void)? = nil) {
        guard let session = auth.session else {
            // TODO: handle this
            fatalError()
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        
        let parameters: [String: Any] = ["name": name]
        let request = Alamofire.request(SpotifyEndpoint.createPlaylist(userID: userID).urlString,
                                        method: .post,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments),
                let playlistDictionary = json as? [String: Any],
                let playlist = Playlist.init(dictionary: playlistDictionary) {
                self.playlists.insert(playlist, at: 0)
                completion?(playlist)
            } else {
                completion?(nil)
            }
        }
    }
    
    func update(playlist: Playlist, withName name: String, userID: String, completion: ((_ playlist: Playlist?) -> Void)? = nil) {
        guard let session = auth.session else {
            // TODO: handle this
            fatalError()
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let parameters: [String: Any] = ["name": name]
        let request = Alamofire.request(SpotifyEndpoint.updatePlaylist(userID: userID, playlistID: playlist.id).urlString,
                                        method: .put,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments),
                let playlistDictionary = json as? [String: Any],
                let playlist = Playlist.init(dictionary: playlistDictionary) {
                if let index = self.playlists.index(where: { $0.id == playlist.id }) {
                    self.playlists[index] = playlist
                } else {
                    self.playlists.insert(playlist, at: 0)
                }
                completion?(playlist)
            } else {
                completion?(nil)
            }
        }
    }
    
}
