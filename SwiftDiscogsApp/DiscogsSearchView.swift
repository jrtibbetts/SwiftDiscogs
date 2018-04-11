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

// MARK: -

/// The root view of the `DiscogsSearchViewController`.
final class DiscogsSearchView: UIView, DiscogsSearchDisplay, UISearchBarDelegate {

    // MARK: Outlets

    /// A `UISearchBar` that's configured in the storyboard, and whose
    /// properties are then copied into the search controller's search bar
    /// when `viewDidLoad()` is called.
    @IBOutlet private(set) weak var dummySearchBar: UISearchBar?

    /// The button that will launch the Discogs service's authorization web
    /// page, if necessary.
    @IBOutlet private(set) weak var signInButton: UIButton?

    /// The button for signing out of the Discogs service.
    @IBOutlet private(set) weak var signOutButton: UIButton?

    /// The label that displays the user's name after sign-in was successful.
    @IBOutlet private(set) weak var signedInAsLabel: UILabel?

    /// The view that contains the `signOutButton` and `signedInAsLabel`.
    @IBOutlet private(set) weak var signOutView: UIView?

    // MARK: Other properties

    /// The search bar with which the view was set up.
    private(set) var searchBar: UISearchBar?

    /// Indicates whether the user is current signed in to Discogs.
    private(set) var signedIn: Bool = false

    /// The string format for the `signedInAsLabel`. This value should be
    /// captured from the `signedInAsLabel` when this view is set up.
    fileprivate var signedInAsLabelFormat: String!

    // MARK: UISearchBarDelegate

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Prevent search-bar editing if the user's not signed in.
        return signedIn
    }

    // MARK: DiscogsSearchDisplay

    /// Configure the view.
    func setUp(searchController: UISearchController,
               navigationItem: UINavigationItem) {
        signedInAsLabelFormat = signedInAsLabel?.text
        signOutView?.isHidden = true
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true

        setUp(searchBar: searchController.searchBar)

        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func tearDown() {
        // Nothing.
    }

    func signedInAs(userName: String) {
        signedIn = true
        signInButton?.isHidden = true
        signOutView?.isHidden = false
        signedInAsLabel?.text = String(format: signedInAsLabelFormat, userName)
    }

    func signedOut() {
        // Even though the signed-in label will be hidden now, clear the
        // username from it to avoid any potential security risk.
        signedInAsLabel?.text = signedInAsLabelFormat
        signInButton?.isHidden = false
        signOutView?.isHidden = true
        signedIn = false
    }

    func willSignIn() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.searchBar?.alpha = CGFloat(1.0)
            }, completion: nil)
    }

    func willSignOut() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.searchBar?.alpha = CGFloat(0.5)
            }, completion: nil)
    }

    // MARK: Other functions

    // Copy the dummySearchBar's settings over to the search controller's
    // bar, then remove the dummy.
    fileprivate func setUp(searchBar: UISearchBar) {
        searchBar.placeholder = dummySearchBar?.placeholder
        searchBar.scopeButtonTitles = dummySearchBar?.scopeButtonTitles
        searchBar.delegate = self
        self.searchBar = searchBar
        dummySearchBar?.removeFromSuperview()
        dummySearchBar = nil
    }

}
