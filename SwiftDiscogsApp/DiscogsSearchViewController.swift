//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

/// Allows the user to search the Discogs database for artists, releases, and
/// labels.
final class DiscogsSearchViewController: UIViewController, UISearchControllerDelegate {

    // MARK: Properties

    @IBOutlet weak var display: DiscogsSearchDisplay?

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

        return searchController
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        display?.setUp(searchController: searchController, navigationItem: navigationItem)
    }

    // MARK: - Actions

    @IBAction func signInToDiscogs() {
        let promise = DiscogsClient.singleton?.authorize(presentingViewController: self,
                                                         callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise?.then { [weak self] (credential) in
            self?.display?.signedInAs(userName: "Fatty Arbuckle")
            }.catch { (error) in
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

    @IBAction func signOutOfDiscogs() {
        display?.willSignOut()

        // TODO: Call the sign-out method that doesn't yet exist.
        display?.signedOut()
    }
}
