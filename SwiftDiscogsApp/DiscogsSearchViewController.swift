//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

/// Allows the user to search the Discogs database for artists, releases, and
/// labels.
final class DiscogsSearchViewController: UIViewController, UISearchControllerDelegate {

    // MARK: - Outlets

    /// A `UISearchBar` that's configured in the storyboard, and whose
    /// properties are then copied into the search controller's search bar
    /// when `viewDidLoad()` is called.
    @IBOutlet weak var dummySearchBar: UISearchBar?

    // MARK: - Other properties

    /// The search bar that's managed and installed by the `searchController`.
    fileprivate var searchBar: UISearchBar {
        return searchController.searchBar
    }

    fileprivate lazy var searchController: UISearchController = {
        // Load the search results controller from the storyboard.
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle:  bundle)
        let searchResultsController
            = storyboard.instantiateViewController(withIdentifier: "searchResults") as? DiscogsSearchResultsController
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true

        return searchController
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // This is the iOS 11 way of adding the search bar. No more adding it
        // to the table view's header view.
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        // Copy the dummySearchBar's settings over to the search controller's
        // bar, then remove the dummy.
        searchBar.placeholder = dummySearchBar?.placeholder
        searchBar.scopeButtonTitles = dummySearchBar?.scopeButtonTitles
        dummySearchBar?.removeFromSuperview()
        dummySearchBar = nil
    }

    // MARK: - Actions

    @IBAction func signInToDiscogs() {
        let promise = DiscogsClient.singleton?.authorize(presentingViewController: self,
                                                         callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise?.catch { (error) in
            let alertTitle = NSLocalizedString("discogsSignInFailed",
                                               tableName: nil,
                                               bundle: Bundle(for: type(of: self)),
                                               value: "Discogs sign-in failed",
                                               comment: "Title of the alert that appears when sign-in is unsuccessful.")
            let alertController = UIAlertController(title: alertTitle,
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
