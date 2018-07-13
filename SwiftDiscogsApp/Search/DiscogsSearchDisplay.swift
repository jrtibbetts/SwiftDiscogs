//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Implemented by objects that control the UI components of the
/// `DiscogsSearchViewController`.
public protocol DiscogsSearchDisplay: DiscogsDisplay {

    /// Called when the user has successfully signed in to Discogs.
    ///
    /// - parameter userName: The Discogs username that was logged in.
    func signedInAs(userName: String)

    /// Called when the user has signed out of Discogs.
    func signedOut()

    /// Called when the user has tapped the Discogs sign-in button, but before
    /// the user has completed the sign-in process.
    func willSignIn()

    /// Called when the user has tapped the Discogs sign-out button, but before
    /// the user has completed the sign-out process.
    func willSignOut()

}
