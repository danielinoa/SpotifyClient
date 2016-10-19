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
    
    var id: String {
        guard let id = dictionaryRepresentation["id"] as? String, !id.isEmpty else {
            fatalError("Expects a valid id")
        }
        return id
    }
    
    var name: String {
        guard let name = dictionaryRepresentation["name"] as? String, !id.isEmpty else {
            fatalError("Expects a valid name")
        }
        return name
    }
    
    var imageUrl: String? {
        if let albumDictionary = dictionaryRepresentation["album"] as? [String: Any],
            let imageDictionaries = albumDictionary["images"] as? [[String: Any]],
            let firstImageDictionary = imageDictionaries.first {
            return firstImageDictionary["url"] as? String
        }
        return nil
    }
    
    var artist: String? {
        if let artistDictionaries = dictionaryRepresentation["artists"] as? [[String: Any]] {
            let artistNames = artistDictionaries.flatMap({ $0["name"] as? String })
            return artistNames.joined(separator: " - ")
        }
        return nil
    }
    
    // MARK: -
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String, !id.isEmpty else { return nil }
        guard let name = dictionary["name"] as? String, !name.isEmpty else { return nil }
        self.dictionaryRepresentation = dictionary
    }
    
}
