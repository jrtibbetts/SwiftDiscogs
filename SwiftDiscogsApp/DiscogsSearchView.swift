//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

@objc public protocol DiscogsSearchDisplay {

    func setUp(searchController: UISearchController,
               navigationItem: UINavigationItem)

    func signedInAs(userName: String)

    func signedOut()

    func willSignIn()

    func willSignOut()

}

// MARK: -

class DiscogsSearchView: UIView, DiscogsSearchDisplay, UISearchBarDelegate {

    // MARK: Outlets

    /// A `UISearchBar` that's configured in the storyboard, and whose
    /// properties are then copied into the search controller's search bar
    /// when `viewDidLoad()` is called.
    @IBOutlet weak var dummySearchBar: UISearchBar?

    /// The button that will launch the Discogs service's authorization web
    /// page, if necessary.
    @IBOutlet weak var signInButton: UIButton?

    /// The button for signing out of the Discogs service.
    @IBOutlet weak var signOutButton: UIButton?

    /// The label that displays the user's name after sign-in was successful.
    @IBOutlet weak var signedInAsLabel: UILabel?

    /// The view that contains the `signOutButton` and `signedInAsLabel`.
    @IBOutlet weak var signOutView: UIView?

    // MARK: Other properties

    var searchController: UISearchController?

    var realSearchBar: UISearchBar?

    var navigationItem: UINavigationItem?

    var signedIn: Bool = false

    /// The string format for the `signedInAsLabel`. This value should be
    /// captured from the `signedInAsLabel` when this view is set up.
    fileprivate var signedInAsLabelFormat: String!

    // MARK: UISearchBarDelegate

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
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
        self.searchController = searchController

        setUp(searchBar: searchController.searchBar)

        // This is the iOS 11 way of adding the search bar. No more adding it
        // to the table view's header view.
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem = navigationItem
    }

    func signedInAs(userName: String) {
        signedIn = true
        signInButton?.isHidden = true
        signOutView?.isHidden = false
        signedInAsLabel?.text = String(format: signedInAsLabelFormat, userName)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.realSearchBar?.alpha = CGFloat(1.0)
        }, completion: nil)
    }

    func signedOut() {
        signInButton?.isHidden = false
        signOutView?.isHidden = true
    }

    func willSignIn() {
        // Empty.
    }

    func willSignOut() {
        navigationItem?.searchController = nil
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.realSearchBar?.alpha = CGFloat(0.5)
        }) { [weak self] (completed) in
            self?.signedIn = false
        }
    }

    // MARK: Other functions

    // Copy the dummySearchBar's settings over to the search controller's
    // bar, then remove the dummy.
    fileprivate func setUp(searchBar: UISearchBar) {
        searchBar.placeholder = dummySearchBar?.placeholder
        searchBar.scopeButtonTitles = dummySearchBar?.scopeButtonTitles
        searchBar.delegate = self
        realSearchBar = searchBar
        dummySearchBar?.removeFromSuperview()
        dummySearchBar = nil
    }

}
