//
//  SpotifySession.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation

/**
 This class represents an expirable user session managed by SpotifyAuth.
 */
final class SpotifySession: NSObject, NSCoding {
    
    let dictionaryRepresentation: [String: Any]
    let expirationDate: Date
    
    var isExpired: Bool {
        return Date() > expirationDate
    }
    
    var accessToken: String {
        return dictionaryRepresentation["access_token"] as!  String
    }
    
    var refreshToken: String {
        return dictionaryRepresentation["refresh_token"] as! String
    }
    
    // MARK: - Lifecycle
    
    init?(tokensDictionary: [String: Any]) {
        guard let expiresIn = tokensDictionary["expires_in"] as? TimeInterval else {
            return nil
        }
        expirationDate = Date().addingTimeInterval(expiresIn)
        dictionaryRepresentation = tokensDictionary
    }
    
    // MARK: - NSCoding
    
    init?(coder aDecoder: NSCoder) {
        guard let dictionary = aDecoder.decodeObject(forKey: "dictionaryRepresentation") as? [String: Any] else { return nil }
        self.dictionaryRepresentation = dictionary
        
        let expirationDateTimeInterval = aDecoder.decodeDouble(forKey: "expirationDateTimeInterval")
        self.expirationDate = Date(timeIntervalSince1970: expirationDateTimeInterval)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dictionaryRepresentation, forKey: "dictionaryRepresentation")
        aCoder.encode(expirationDate.timeIntervalSince1970, forKey: "expirationDateTimeInterval")
    }
    
    // MARK: - Serialization
    
    var serialized: Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    static func deserialize(with data: Data) -> SpotifySession? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SpotifySession
    }
    
}
