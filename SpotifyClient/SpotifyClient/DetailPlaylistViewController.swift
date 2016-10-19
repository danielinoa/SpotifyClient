//
//  DetailPlaylistViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

protocol DetailPlaylistViewControllerDelegate: class {
    func renamed(name: String, playlist: Playlist, in: DetailPlaylistViewController)
}

/**
 This view controller manages and displays a playlist.
 */
final class DetailPlaylistViewController: UITableViewController {
    
    weak var delegate: DetailPlaylistViewControllerDelegate?
    
    let tracksDataSource: PlaylistsTracksDataSource
    
    fileprivate var tracks: [Track] {
        return tracksDataSource.tracks
    }
    
    private var playlist: Playlist {
        didSet {
            title = playlist.name
        }
    }
    
    // MARK: - Lifecycle
    
    init(playlist: Playlist) {
        self.playlist = playlist
        self.tracksDataSource = PlaylistsTracksDataSource(playlist: playlist)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not yet implemented.") }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError("\(#function) not yet implemented.") }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        let actionBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchController))
        navigationItem.rightBarButtonItems = [actionBarButtonItem, searchBarButtonItem]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracksDataSource.fetchTracks { _ in
            self.tableView.reloadData()
        }
    }

    // MARK: - Actions
    
    @objc private func actionButtonTapped() {
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
        let alertController = UIAlertController(title: nil, message: "Rename playlist", preferredStyle: .alert)
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
    
    @objc private func showSearchController() {
        let alertController = UIAlertController(title: "Search New Track", message: "", preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Track name..."
        }
        let createAction = UIAlertAction(title: "Search", style: .default, handler: { _ in
            if let searchQuery = alertController.textFields?.first?.text, !searchQuery.isEmpty {
                let searchTracksController = SearchTracksViewController(searchQuery: searchQuery)
                searchTracksController.delegate = self
                self.show(searchTracksController, sender: self)
            }
        })
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in })
        alertController.addAction(createAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: {})
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tracks"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "trackCell")
        cell.textLabel?.text = tracks[indexPath.row].name
        cell.detailTextLabel?.text = tracks[indexPath.row].artist
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        let trackViewController = TrackViewController(track: track)
        present(trackViewController, animated: true, completion: nil)
    }
    
}


extension DetailPlaylistViewController: SearchTracksViewControllerDelegate {
    
    func added(tracks: [Track], in searchController: SearchTracksViewController) {
        if let topViewController = navigationController?.topViewController, topViewController == searchController {
            let _ = navigationController?.popViewController(animated: true)
        }
        tracksDataSource.addTracks(tracks: tracks) { _ in
            self.tracksDataSource.fetchTracks { _ in
                self.tableView.reloadData()
            }
        }
    }
    
}

