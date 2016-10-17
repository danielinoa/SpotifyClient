//
//  PlaylistTableViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

protocol PlaylistViewControllerDelegate: class {
    func renamed(name: String, playlist: Playlist, in: PlaylistViewController)
}

/**
 This view controller manages and displays a playlist.
 */
class PlaylistViewController: UITableViewController {
    
    weak var delegate: PlaylistViewControllerDelegate?
    
    private var playlist: Playlist {
        didSet {
            title = playlist.name
        }
    }
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError("") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        let actionBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [actionBarButtonItem]
    }

    // MARK: - 
    
    @objc private func actionButtonTapped(_ sender: Any? = nil) {
        let actionController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit Playlist", style: .default, handler: { _ in
            self.showEditAlertController()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController.addAction(editAction)
        actionController.addAction(cancelAction)
        present(actionController, animated: true, completion: {})
    }
    
    private func showEditAlertController() {
        let alertController = UIAlertController(title: "Edit Playlist", message: "Rename playlist", preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.text = self.playlist.name
            textfield.placeholder = "Playlist name..."
        }
        let createAction = UIAlertAction(title: "Done", style: .default, handler: { _ in
            if let playlistName = alertController.textFields?.first?.text, !playlistName.isEmpty {
                self.playlist.name = playlistName
                self.delegate?.renamed(name: playlistName, playlist: self.playlist, in: self)
            }
        })
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in })
        alertController.addAction(createAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: {})
    }

}
