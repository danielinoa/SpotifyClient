//
//  SpotifyAuth.swift
//  SpotifyClient
//
//  Created by Daniel Inoa on 10/16/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import Foundation
import Alamofire

protocol SpotifyAuthDelegate: class {
    func sessionUpdated(in spotifyAuth: SpotifyAuth)
}

/**
 This class manages Spotify authentication, sessions and tokens.
 */
final class SpotifyAuth {
    
    /*
     Sessions should be stored using Keychain.
     Sessions are currently stored using UserDefaults.
     */
    
    static let shared = SpotifyAuth()
    
    weak var delegate: SpotifyAuthDelegate?
    
    // MARK: - Credentials
    
    var clientID: String {
        fatalError("Remove this fatal error and assign/return a valid clientID. \(#file)")
    }
    
    var clientSecret: String {
        fatalError("Remove this fatal error and assign/return a valid clientSecret. \(#file)")
    }
    
    
    let redirectURI = "spotifyclient://"
    let responseType = "code"
    let scope = "playlist-modify-public"
    
    // MARK: - Authentication
    
    /**
     Returns the url for user authentication.
     URL callbacks are handled through `handleAuthentication(_:URL)`
     */
    var authenticationURL: URL {
        let clientIdQuery = URLQueryItem(name: "client_id", value: clientID)
        let redirectUriQuery = URLQueryItem(name: "redirect_uri", value: redirectURI)
        let responseTypeQuery = URLQueryItem(name: "response_type", value: responseType)
        let scopeTypeQuery = URLQueryItem(name: "scope", value: scope)
        var urlComponents = URLComponents(string: SpotifyEndpoint.authentication.urlString)
        urlComponents?.queryItems = [clientIdQuery, redirectUriQuery, responseTypeQuery, scopeTypeQuery]
        if let url = urlComponents?.url {
            return url
        } else {
            fatalError("authenticationURL formation failed.")
        }
    }
    
    /**
     This function handles an authentication callback url.
     If the user authenticated successfully this function will retrieve the authentication code,
     which can then be exchanged for an access token.
     */
    func handle(authenticationUrl url: URL) {
        guard let components = URLComponents.init(string: url.absoluteString), let queryItems = components.queryItems else {
            // TODO: handle failure
            return
        }
        if let codeItem = queryItems.first(where: { $0.name == "code" }) {
            authenticationCode = codeItem.value
        } else {
            // TODO: handle access_denied or error
        }
    }
    
    private var authenticationCode: String? {
        get { return UserDefaults.standard.string(forKey: "authorizationCode") }
        set { UserDefaults.standard.set(newValue, forKey: "authorizationCode") }
    }
    
    /**
     Returns true if there is a valid session.
     */
    var isAuthenticated: Bool {
        guard let session = session else {
            return false
        }
        return !session.isExpired
    }
    
    // MARK: - Tokens
    
    /**
     Retrieves an access token from authorization code.
     */
    func fetchAccessToken() {
        guard let code = authenticationCode else {
            assertionFailure("Authentication code required to fetch access token.")
            return
        }
        let parameters: [String: Any] = ["grant_type":"authorization_code",
                                         "code": code,
                                         "redirect_uri": redirectURI,
                                         "client_id": clientID,
                                         "client_secret": clientSecret]
        let request = Alamofire.request(SpotifyEndpoint.token.urlString, method: .post, parameters: parameters)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments),
                let dictionary = json as? [String: Any] {
                    let session = SpotifySession(tokensDictionary: dictionary)
                    self.session = session
                    self.fetchCurrentUser(completion: { _ in
                        self.delegate?.sessionUpdated(in: self)
                    })
            } else {
                
            }
        }
    }
    
    // TODO: implement token refresh function
    func refreshToken() {
        fatalError("\(#function) not yet implemented.")
    }
    
    // MARK: - Session
    
    /**
     Returns the stored session.
     Returns nil if no valid session has been stored.
     */
    private(set) var session: SpotifySession? {
        get {
            guard let sessionData = UserDefaults.standard.data(forKey: "sessionData") else { return nil }
            guard let session = SpotifySession.deserialize(with: sessionData) else { return nil }
            return session
        }
        set {
            UserDefaults.standard.set(newValue?.serialized, forKey: "sessionData")
        }
    }
    
    /**
     Removes stored session and user, and notifes delegate of session change.
     */
    func clear() {
        session = nil
        user = nil
        delegate?.sessionUpdated(in: self)
    }
    
    // MARK: - User
    
    private(set) var user: SpotifyUser? {
        get {
            guard let userData = UserDefaults.standard.data(forKey: "userData") else { return nil }
            guard let user = SpotifyUser.deserialize(with: userData) else { return nil }
            return user
        }
        set {
            UserDefaults.standard.set(newValue?.serialized, forKey: "userData")
        }
    }
    
    private func fetchCurrentUser(completion: ((_ user: SpotifyUser?) -> Void)? = nil) {
        guard let session = SpotifyAuth.shared.session else {
            completion?(nil)
            return
        }
        let headers = Alamofire.HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(session.accessToken)"))
        let request = Alamofire.request(SpotifyEndpoint.me.urlString, headers: headers)
        request.responseJSON { response in
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments), let dictionary = json as? [String: Any] {
                if let user = SpotifyUser(dictionary: dictionary) {
                    self.user = user
                    completion?(user)
                } else {
                    completion?(nil)
                }
            } else {
                completion?(nil)
            }
        }
    }
    
}
