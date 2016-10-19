//
//  PlaylistsViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit
import Alamofire

/**
 This view controller manages and displays a set of playlists.
 */
final class PlaylistsViewController: UITableViewController {
    
    fileprivate let playlistsDataSource = PlaylistsDataSource()
    
    private var playlists: [Playlist] {
        return playlistsDataSource.playlists
    }
    
    private var auth: SpotifyAuth {
        return SpotifyAuth.shared
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Playlists"
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction(_:)))
        let addPlaylistBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylistAction))
        navigationItem.leftBarButtonItem = logoutBarButtonItem
        navigationItem.rightBarButtonItem = addPlaylistBarButtonItem
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playlistsDataSource.fetchPlaylists { _ in
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc private func logoutAction(_ sender: AnyObject) {
        auth.clear()
    }
    
    @objc private func addPlaylistAction() {
        let alertController = UIAlertController(title: "New Playlist", message: "Enter a name for your new playlist", preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Playlist name..."
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
             if let playlistName = alertController.textFields?.first?.text, !playlistName.isEmpty {
                self.playlistsDataSource.createPlaylist(name: playlistName) { _ in
                    self.tableView.reloadData()
                }
             }
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in })
        alertController.addAction(createAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: {})
    }
    
    @objc private func refresh(_ sender: AnyObject?) {
        playlistsDataSource.fetchPlaylists { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "playlistCell")
        let playlist = playlists[indexPath.row]
        cell.textLabel?.text = playlist.name
        if let numberOfTracks = playlist.numberOfTracks {
            cell.detailTextLabel?.text = "\(numberOfTracks) tracks"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let playlistViewController = DetailPlaylistViewController(playlist: playlist)
        playlistViewController.delegate = self
        show(playlistViewController, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension PlaylistsViewController: DetailPlaylistViewControllerDelegate {
    
    // MARK: - DetailPlaylistViewControllerDelegate
    
    func renamed(name: String, playlist: Playlist, in: DetailPlaylistViewController) {
        playlistsDataSource.update(playlist: playlist, withName: name) { _ in
            self.tableView.reloadData()
        }
    }
    
}
