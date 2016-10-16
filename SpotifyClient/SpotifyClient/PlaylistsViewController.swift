//
//  PlaylistsViewController.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit
import Alamofire

final class PlaylistsViewController: UIViewController {

    private var auth: SpotifyAuth {
        return SpotifyAuth.shared
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMe()
    }
    
    private func fetchMe() {
        guard let session = auth.session else {
            fatalError()
        }
        
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let request = Alamofire.request(SpotifyEndpoint.me.urlString, headers: headers)
        request.responseJSON { response in
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                if let dictionary = json as? [String: Any] {
                    print(dictionary)
                    self.title = dictionary["id"] as? String
                } else {
                    
                }
            } catch {
                
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        auth.clearSession()
    }
    
}
