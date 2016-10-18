//
//  Track.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/17/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation

/**
 This struct represents a Spotify track.
 */
struct Track {
    
    let dictionaryRepresentation: [String: Any]
    
    private var trackDictionary: [String: Any] {
        guard let trackDictionary = dictionaryRepresentation["track"] as? [String: Any] else {
            fatalError("Expects a track dictionary")
        }
        return trackDictionary
    }
    
    var id: String {
        guard let id = trackDictionary["id"] as? String, !id.isEmpty else {
            fatalError("Expects a valid id")
        }
        return id
    }
    
    var name: String {
        guard let name = trackDictionary["name"] as? String, !id.isEmpty else {
            fatalError("Expects a valid name")
        }
        return name
    }
    
    init?(dictionary: [String: Any]) {
        guard let trackDictionary = dictionary["track"] as? [String: Any] else { return nil }
        guard let id = trackDictionary["id"] as? String, !id.isEmpty else { return nil }
        guard let name = trackDictionary["name"] as? String, !name.isEmpty else { return nil }
        dictionaryRepresentation = dictionary
    }
    
}
