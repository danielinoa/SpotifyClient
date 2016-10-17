//
//  Playlist.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation

/**
 This struct represents a Spotify playlist.
 */
struct Playlist: CustomStringConvertible {
    
    let dictionaryRepresentation: [String: Any]
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String, !id.isEmpty else { return nil }
        guard let name = dictionary["name"] as? String, !name.isEmpty else { return nil }
        self.id = id
        self.name = name
        dictionaryRepresentation = dictionary
    }
    
    // MARK: - 
    
    let id: String
    var name: String
    
    var numberOfTracks: Int? {
        guard let tracksDictionary = dictionaryRepresentation["tracks"] as? [String: Any] else {
            return nil
        }
        return tracksDictionary["total"] as? Int
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "Playlist id: \(id), name: \(name)"
    }
    
}
