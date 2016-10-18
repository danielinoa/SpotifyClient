//
//  SpotifyUser.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/17/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation
import Alamofire

final class SpotifyUser: NSObject, NSCoding {
    
    let dictionaryRepresentation: [String: Any]
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String, !id.isEmpty else { return nil }
        dictionaryRepresentation = dictionary
    }
    
    // MARK: - 
    
    var id: String {
        guard let id = dictionaryRepresentation["id"] as? String, !id.isEmpty else {
            fatalError("Expects a valid id")
        }
        return id
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        guard let dictionary = aDecoder.decodeObject(forKey: "dictionaryRepresentation") as? [String: Any] else { return nil }
        self.dictionaryRepresentation = dictionary
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dictionaryRepresentation, forKey: "dictionaryRepresentation")
    }
    
    // MARK: - Serialization
    
    var serialized: Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    static func deserialize(with data: Data) -> SpotifyUser? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SpotifyUser
    }
    
}
