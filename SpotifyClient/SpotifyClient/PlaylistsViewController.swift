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
    
    fileprivate var playlists: [Playlist] {
        return playlistsDataSource.playlists
    }
    
    private var auth: SpotifyAuth {
        return SpotifyAuth.shared
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PlaylistTableViewCell.classForCoder(), forCellReuseIdentifier: PlaylistTableViewCell.cellIdentifier)
        
        title = "Playlists"
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction(_:)))
        let addPlaylistBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylistAction))
        
        navigationItem.leftBarButtonItem = logoutBarButtonItem
        navigationItem.rightBarButtonItem = addPlaylistBarButtonItem
        fetchMe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playlistsDataSource.fetchPlaylists { _ in
            self.tableView.reloadData()
        }
    }
    
    fileprivate var userID: String?
    
    private func fetchMe(completion: ((_ userID: String) -> Void)? = nil) {
        guard let session = auth.session else {
            // TODO: handle this
            fatalError()
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let request = Alamofire.request(SpotifyEndpoint.me.urlString, headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments), let dictionary = json as? [String: Any] {
                if let userID = dictionary["id"] as? String {
                    self.userID =  userID
                    completion?(userID)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func logoutAction(_ sender: AnyObject) {
        auth.clearSession()
    }
    
    @objc private func addPlaylistAction() {
        let alertController = UIAlertController(title: "New Playlist", message: "Enter a name for your new playlist", preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Playlist name..."
        }
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
             if let playlistName = alertController.textFields?.first?.text {
                // make sure is not empty
                if let userID = self.userID {
                    self.playlistsDataSource.createPlaylist(name: playlistName, userID: userID, completion: { _ in
                        self.tableView.reloadData()
                    })
                }
                // model.addPlaylist(name: textField.text)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.cellIdentifier, for: indexPath) as! PlaylistTableViewCell
        cell.configure(playlist: playlists[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let playlistViewController = PlaylistViewController(playlist: playlist)
        playlistViewController.delegate = self
        show(playlistViewController, sender: self)
    }
    
}

extension PlaylistsViewController: PlaylistViewControllerDelegate {
    
    // MARK: - PlaylistViewControllerDelegate
    
    func renamed(name: String, playlist: Playlist, in: PlaylistViewController) {
        if let userID = self.userID {
            playlistsDataSource.update(playlist: playlist, withName: name, userID: userID, completion: { _ in
                self.tableView.reloadData()
            })
        }
    }
    
}
