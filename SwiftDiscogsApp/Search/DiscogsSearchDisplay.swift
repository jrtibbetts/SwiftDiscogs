//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Implemented by the `DiscogsSearchView` and mock views for testing the
/// `DiscogsSearchViewController`.
@objc public protocol DiscogsSearchDisplay {

    /// Configure the display with the search controller and navigation item
    /// that it will customize.
    ///
    /// - parameter searchController: The `UISearchController`.
    /// - parameter navigationItem: The navigation item.
    func setUp(searchController: UISearchController,
               navigationItem: UINavigationItem)

    /// Stop any restartable services.
    func tearDown()

    /// Called when the user has successfully signed into Discogs.
    ///
    /// - parameter userName: The name of the signed-in user.
    func signedInAs(userName: String)

    /// Called when the user has successfully signed out of Discogs.
    func signedOut()

    /// Called when the user's about to sign in to Discogs.
    func willSignIn()

    /// Called when the user's about to sign out of Discogs.
    func willSignOut()

}
