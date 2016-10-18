//
//  PlaylistTableViewCell.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "playlistCell"
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configuration

    func configure(playlist: Playlist) {
        textLabel?.text = playlist.name
        if let numberOfTracks = playlist.numberOfTracks {
            detailTextLabel?.text = "\(numberOfTracks) tracks"
        }
    }
    
}
