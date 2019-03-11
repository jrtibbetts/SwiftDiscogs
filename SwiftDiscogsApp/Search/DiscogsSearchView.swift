//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// The root view of the `DiscogsSearchViewController`.
open class DiscogsSearchView: DiscogsDisplay, SpinnerBusyView,  UISearchBarDelegate {

    // MARK: - Private Outlets

    /// The button that will launch the Discogs service's authorization web
    /// page, if necessary.
    @IBOutlet private weak var signInButton: UIButton?

    /// The button for signing out of the Discogs service.
    @IBOutlet private weak var signOutButton: UIButton?

    /// The busy indicator.
    @IBOutlet public weak var spinner: UIActivityIndicatorView?

    /// The stack view that contains the sign-in view, the search results table,
    /// and the `unavailableView`.
    @IBOutlet private weak var toggleStackView: ToggleStackView?

    /// The view that's shown when the user taps the My Collection search scope
    /// button, which isn't implemented yet.
    @IBOutlet private weak var unavailableView: UIView?

    // MARK: - Other Properties

    /// Indicates whether the user is currently signed in to Discogs.
    private var signedIn: Bool = false

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
    open override func setUp(navigationItem: UINavigationItem) {
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

    private func setUp(searchBar: UISearchBar) {
        searchBar.delegate = self
        searchBar.scopeButtonTitles = [L10n.allOfDiscogsSearchScopeTitle, L10n.userCollectionSearchScopeTitle]
        searchBar.selectedScopeButtonIndex = DiscogsSearchViewController.SearchScope.allOfDiscogs.rawValue
        searchBar.showsScopeBar = true
    }

}
