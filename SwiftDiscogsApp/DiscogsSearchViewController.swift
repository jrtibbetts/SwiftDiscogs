//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

/// Allows the user to search the Discogs database for artists, releases, and
/// labels.
final class DiscogsSearchViewController: UIViewController, UISearchControllerDelegate {

    // MARK: Outlets

    /// The object responsible for managing the on-screen contents of the
    /// Discogs search, which helps keep the size of this view controller down.
    @IBOutlet weak var display: DiscogsSearchDisplay?

    // MARK: Properties

    /// The Discogs client.
    var discogsClient: Discogs?

    /// The `UISearchController`. It displays its results in a separate view
    /// controller (the `DiscogsSearchResultsController`).
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

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        display?.setUp(searchController: searchController, navigationItem: navigationItem)
    }

    // MARK: Actions

    @IBAction func signInTapped(source: UIButton?) {
        signInToDiscogs()
    }

    @IBAction func signOutTapped(source: UIButton?) {
        signOutOfDiscogs()
    }

    // MARK: Other Functions

    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    ///
    /// - parameter completion: An optional function that's called after the
    ///             the user has successfully signed in.
    func signInToDiscogs(completion: (() -> Void)? = nil) {
        display?.willSignIn()
        
        let promise = discogsClient?.authorize(presentingViewController: self,
                                               callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise?.then { [weak self] (credential) -> Void in
            // TODO: Use the user's real name.
            self?.display?.signedInAs(userName: "Fatty Arbuckle")
            completion?()
            }.catch { (error) in    // not weak self because of Bundle(for:)
                let alertTitle = NSLocalizedString("discogsSignInFailed",
                                                   tableName: nil,
                                                   bundle: Bundle(for: type(of: self)),
                                                   value: "Discogs sign-in failed",
                                                   comment: "Title of the alert that appears when sign-in is unsuccessful.")
                self.presentAlert(for: error, title: alertTitle)
        }
    }

    /// Sign out of the Discogs service, notifying the display when it's about
    /// to do so and after the user has logged out successfully.
    ///
    /// - parameter completion: An optional function that's called after the
    ///             the user has successfully signed out.
    func signOutOfDiscogs(completion: (() -> Void)? = nil) {
        display?.willSignOut()

        // TODO: Call the sign-out method that doesn't yet exist.
        display?.signedOut()
        completion?()
    }

}
