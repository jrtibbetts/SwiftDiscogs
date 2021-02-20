//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit
import UIKit

/// An `AuthorizedJSONClient` implementation that uses OAuth 1 for
/// authentication and authorization.
open class OAuth1JSONClient: AuthorizedJSONClient {

    /// The OAuth engine. Note that there's already an `oAuth` property in the
    /// superclass, and its type is `OAuthSwift`, which is the superclass of
    /// `OAuth1Swift`. This one is here so that we don't have to cast the
    /// `oAuth` property to the desired type.
    private let oAuth1: OAuth1Swift
    
    /// Initialize the client with the app's hashes on the server, as well as
    /// the server's various OAuth-related URLs.
    ///
    /// - parameter consumerKey: The hash that identifies the app that this
    ///             client communicates with. It's also called a client key.
    /// - parameter consumerSecret: The password hash for the server app. This
    ///             value should not be included in publicly-visible code.
    /// - parameter requestTokenUrl: The server endpoint for getting an OAuth
    ///             request token.
    /// - parameter authorizeUrl: The URL of the app's sign-in page.
    /// - parameter accessTokenUrl: The URL where the OAuth client can exchange
    ///             a request token for an access token.
    /// - parameter baseUrl: The service's root-level URL. All relative paths
    ///             that are passed to the various REST functions will be
    ///             resolved against this URL. If it's `nil`, then all paths
    ///             must be absolute URL strings.
    public init(consumerKey: String,
                consumerSecret: String,
                requestTokenUrl: String,
                authorizeUrl: String,
                accessTokenUrl: String,
                baseUrl: URL? = nil,
                jsonDecoder: JSONDecoder) {
        oAuth1 = OAuth1Swift(consumerKey: consumerKey,
                             consumerSecret: consumerSecret,
                             requestTokenUrl: requestTokenUrl,
                             authorizeUrl: authorizeUrl,
                             accessTokenUrl: accessTokenUrl)
        super.init(oAuth: oAuth1, authorizeUrl: authorizeUrl, baseUrl: baseUrl, jsonDecoder: jsonDecoder)
    }

    /// Launch the service's sign-in page in a modal Safari web view. After the
    /// user has successfully authenticated, the web page will be redirected to
    /// the callback URL, which is unique to the client application.
    ///
    /// - parameter presentingViewController: The view controller over which the
    ///             Safari view controller will be presented modally.
    /// - parameter callbackUrlString: The URL that the web view will load
    ///             after authentication succeeds.
    ///
    /// - returns:  A `Promise` containing whatever type of data is sent back
    ///             by the server after authentication succeeds.
    open func authorize(presentingViewController: UIViewController,
                        callbackUrlString: String) -> Promise<OAuthSwiftCredential> {
        if let credential = oAuthCredential, !credential.isTokenExpired() {
            return Promise<OAuthSwiftCredential>.value(credential)
        } else {
            oAuth1.authorizeURLHandler = SafariURLHandler(viewController: presentingViewController, oauthSwift: oAuth)

            return Promise<OAuthSwiftCredential> { [weak self] (seal) in
                _ = self?.oAuth1.authorize(withCallbackURL: callbackUrlString) { (result) in
                    switch result {
                    case .success(let (credential, _, _)):
                        seal.fulfill(credential)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            }
        }
    }
    
}
