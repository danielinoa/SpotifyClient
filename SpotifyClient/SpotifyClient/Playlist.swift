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
        guard let owner = (dictionary["owner"] as? [String: Any])?["id"] as? String, !owner.isEmpty else { return nil }
        self.name = name
        dictionaryRepresentation = dictionary
    }
    
    // MARK: - 
    
    var id: String {
        guard let id = dictionaryRepresentation["id"] as? String, !id.isEmpty else {
            fatalError("Expects a valid id")
        }
        return id
    }
    
    /**
     Modifying the name locally, does not modify the name remotely.
     - seealso: `PlaylistsDataSource.update`
     */
    var name: String
    
    var numberOfTracks: Int? {
        guard let tracksDictionary = dictionaryRepresentation["tracks"] as? [String: Any] else {
            return nil
        }
        return tracksDictionary["total"] as? Int
    }
    
    var owner: String {
        guard let owner = (dictionaryRepresentation["owner"] as? [String: Any])?["id"] as? String else {
            fatalError("Expects a valid owner")
        }
        return owner
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "Playlist id: \(id), name: \(name)"
    }
    
}
