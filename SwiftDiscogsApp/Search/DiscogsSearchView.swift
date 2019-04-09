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

    // MARK: - Other Properties

    /// Indicates whether the user is currently signed in to Discogs.
    private var signedIn: Bool = false

    // MARK: - UISearchBarDelegate

    open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Prevent search-bar editing if the user's not signed in.
        return signedIn
    }

    // MARK: - DiscogsDisplay

    /// Configure the view.
    open override func setUp(navigationItem: UINavigationItem) {
        stopActivity()  // stop and hide the spinner
        signedIn = true

        self.navigationItem = navigationItem
        self.navigationItem?.hidesSearchBarWhenScrolling = true

        if let searchController = navigationItem.searchController {
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.delegate = self
        }
    }

    // MARK: - Everything Else

    func selectItem(at indexPath: IndexPath, animated: Bool = true) {
        switch foregroundMode {
        case .collection:
            collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
        case .table:
            tableView?.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
        }
    }

}
