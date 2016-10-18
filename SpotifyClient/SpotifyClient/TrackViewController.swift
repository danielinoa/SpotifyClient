//
//  TrackViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/17/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit
import AlamofireImage

/**
 This view controller displays detail information about a track.
 */
final class TrackViewController: UIViewController {
    
    let track: Track
    
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var trackImageView: UIImageView!
    
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
        // TODO:
    }
    
}
