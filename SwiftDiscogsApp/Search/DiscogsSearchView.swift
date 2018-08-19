//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// The root view of the `DiscogsSearchViewController`.
open class DiscogsSearchView: CollectionAndTableDisplay, DiscogsDisplay, SpinnerBusyView,  UISearchBarDelegate {

    // MARK: - Private Outlets

    /// The button that will launch the Discogs service's authorization web
    /// page, if necessary.
    @IBOutlet fileprivate weak var signInButton: UIButton?

    /// The button for signing out of the Discogs service.
    @IBOutlet fileprivate weak var signOutButton: UIButton?

    /// The busy indicator.
    @IBOutlet public weak var spinner: UIActivityIndicatorView?

    /// The stack view that contains the sign-in view, the search results table,
    /// and the `unavailableView`.
    @IBOutlet fileprivate weak var toggleStackView: ToggleStackView?

    /// The view that's shown when the user taps the My Collection search scope
    /// button, which isn't implemented yet.
    @IBOutlet fileprivate weak var unavailableView: UIView?

    // MARK: - Other Properties

    /// Indicates whether the user is currently signed in to Discogs.
    fileprivate var signedIn: Bool = false

    fileprivate lazy var allOfDiscogsSearchScopeTitle = NSLocalizedString("allOfDiscogsSearchScopeTitle",
                                                                          tableName: nil,
                                                                          bundle: Bundle(for: type(of: self)),
                                                                          value: "All of Discogs",
                                                                          comment: "Search scope label for searching all of Discogs")

    fileprivate lazy var userCollectionSearchScopeTitle = NSLocalizedString("userCollectionSearchScopeTitle",
                                                                            tableName: nil,
                                                                            bundle: Bundle(for: type(of: self)),
                                                                            value: "My Collection",
                                                                            comment: "Search scope label for searching only within the user's collection")


    // MARK: - UISearchBarDelegate

    open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Prevent search-bar editing if the user's not signed in.
        return signedIn
    }

    public func searchBar(_ searchBar: UISearchBar,
                          selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == DiscogsSearchViewController.SearchScope.userCollection.rawValue {
            toggleStackView?.activeView = unavailableView
        } else {
            toggleStackView?.activeView = toggleStackView?.previousActiveView
        }
    }

    // MARK: - DiscogsDisplay

    /// Configure the view.
    open func setUp(navigationItem: UINavigationItem) {
        stopActivity()  // stop and hide the spinner
        signedIn = true

        self.navigationItem = navigationItem
        self.navigationItem?.hidesSearchBarWhenScrolling = false

        if let searchController = navigationItem.searchController {
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.obscuresBackgroundDuringPresentation = false

            setUp(searchBar: searchController.searchBar)
        }

        toggleStackView?.activeView = tableView
    }

    open func tearDown() {
        // Nothing.
    }

    fileprivate func setUp(searchBar: UISearchBar) {
        searchBar.delegate = self
        searchBar.scopeButtonTitles = [allOfDiscogsSearchScopeTitle, userCollectionSearchScopeTitle]
        searchBar.selectedScopeButtonIndex = DiscogsSearchViewController.SearchScope.allOfDiscogs.rawValue
        searchBar.showsScopeBar = true
    }

}
