//
//  TrackViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/17/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TrackViewControllerDelegate: class {
    func removed(track: Track, in: TrackViewController)
}

/**
 This view controller displays detail information about a track.
 */
final class TrackViewController: UIViewController {
    
    let track: Track
    
    @IBOutlet private var trackLabel: UILabel!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var trackImageView: UIImageView!
    
    weak var delegate: TrackViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(track: Track) {
        self.track = track
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not yet implemented.") }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError("\(#function) not yet implemented.") }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackLabel.text = track.name
        artistLabel.text = track.artist
        if let imageUrlString = track.imageUrl, let imageUrl = URL(string: imageUrlString) {
            trackImageView.af_setImage(withURL: imageUrl)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dismissAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAction(_ sender: AnyObject) {
        delegate?.removed(track: track, in: self)
    }
    
}
