//
//  SearchTracksViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/18/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchTracksViewControllerDelegate: class {
    func added(tracks: [Track], in: SearchTracksViewController)
}

/**
 This view manages the search, display, and selection of tracks based on a search query.
 */
class SearchTracksViewController: UITableViewController {
    
    private var tracks: [Track] = []
    
    let searchQuery: String
    
    private var selectedIndices: Set<IndexPath> = [] {
        didSet {
            navigationItem.prompt = selectedIndices.isEmpty ? "Select tracks to add" : "\(selectedIndices.count) tracks selected"
            addBarButtonItem.isEnabled = !selectedIndices.isEmpty
        }
    }
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Add tracks", style: .done, target: self, action: #selector(addTracks))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    weak var delegate: SearchTracksViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not yet implemented.") }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError("\(#function) not yet implemented.") }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = searchQuery
        navigationItem.prompt = "Select tracks to add"
        navigationItem.rightBarButtonItems = [addBarButtonItem]
        fetchTracks { _ in
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    private func fetchTracks(completion: ((_ tracks: [Track]?) -> Void)? = nil) {
        guard let session = SpotifyAuth.shared.session else {
            completion?(nil)
            return
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let endpoint = SpotifyEndpoint.search
        let parameters: [String: Any] = ["q": searchQuery, "type": "track"]
        let request = Alamofire.request(endpoint.urlString, parameters: parameters, headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments), let dictionary = json as? [String: Any],
            let tracksDictionary = dictionary["tracks"] as? [String: Any], let trackDictionaries = tracksDictionary["items"] as? [[String: Any]] {
                let tracks = trackDictionaries.flatMap { Track(dictionary: $0) }
                self.tracks = tracks
                completion?(tracks)
            } else {
                completion?(nil)
            }
        }
    }
    
    @objc private func addTracks() {
        assert(!selectedIndices.isEmpty, "Expects one or more selected indices")
        let selectedTracks = selectedIndices.map({ tracks[$0.row] })
        delegate?.added(tracks: selectedTracks, in: self)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "trackCell")
        cell.textLabel?.text = tracks[indexPath.row].name
        cell.detailTextLabel?.text = tracks[indexPath.row].artist
        
        // Adjusting selection color
        let rowSelected = selectedIndices.contains(indexPath)
        let selectionColor = navigationController?.navigationBar.tintColor ?? UIColor.blue.withAlphaComponent(0.5)
        cell.backgroundColor = rowSelected ? selectionColor : .white
        cell.textLabel?.textColor = rowSelected ? .white : .black
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndices.contains(indexPath) {
            selectedIndices.remove(indexPath)
        } else {
            selectedIndices.insert(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
