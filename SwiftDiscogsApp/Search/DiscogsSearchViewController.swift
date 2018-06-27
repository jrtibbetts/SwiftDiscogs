//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import SwiftDiscogs
import UIKit

/// Allows the user to search the Discogs database for artists, releases, and
/// labels.
open class DiscogsSearchViewController: OutlettedController, UISearchResultsUpdating, DiscogsProvider {

    // MARK: Public Properties

    /// The Discogs client.
    open var discogs: Discogs? = /* MockDiscogs() */ DiscogsClient.singleton

    /// The data model that holds the search results.
    open var searchResultsModel: DiscogsSearchResultsModel? {
        return model as? DiscogsSearchResultsModel
    }

    /// The object responsible for managing the on-screen contents of the
    /// Discogs search, which helps keep the size of this view controller down.
    /// The root view in the storyboard MUST have `DiscogsSearchView` as its
    /// custom class!
    open var searchView: DiscogsSearchView? {
        return view as? DiscogsSearchView
    }

    // MARK: Private Properties

    /// The search results. Changes trigger a reloading of the table and/or
    /// collection.
    open var results: [DiscogsSearchResult]? {
        didSet {
            searchResultsModel?.results = results
            display?.refresh()
        }
    }

    /// The `UISearchController`. It displays its results in a separate view
    /// controller (the `DiscogsSearchResultsController`).
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        return searchController
    }()
    
    // MARK: UIViewController

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            case "showArtist":
                if let navController = segue.destination as? UINavigationController,
                    let artistViewController = navController.topViewController as? DiscogsArtistViewController {
                    artistViewController.artistSearchResult = selectedArtistResult
                }
            default:
                return
            }
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        searchView?.setUp(searchController: searchController, navigationItem: navigationItem)
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
        searchView?.willSignIn()
        
        let promise = discogs?.authorize(presentingViewController: self,
                                               callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise?.then { [weak self] (credential) -> Void in
            // TODO: Use the user's real name.
            self?.searchView?.signedInAs(userName: "Fatty Arbuckle")

            // This is the iOS 11 way of adding the search bar. No more adding it
            // to the table view's header view.
            self?.navigationItem.searchController = self?.searchController
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
        searchView?.willSignOut()

        // TODO: Call the sign-out method that doesn't yet exist.
        searchView?.signedOut()
        navigationItem.searchController = nil
        completion?()
    }

    // MARK: UISearchResultsUpdating

    open func updateSearchResults(for searchController: UISearchController) {
        let searchTerms = searchController.searchBar.text ?? ""
        let promise: Promise<DiscogsSearchResults>? = discogs?.search(for: searchTerms, type: "Artist")
        promise?.then { [weak self] (searchResults) -> Void in
            self?.results = searchResults.results?.filter { $0.type == "artist" }
            }.catch { [weak self] (error) in
                self?.results = nil
                self?.presentAlert(for: error)
        }
    }

    // MARK: Everything Else

    fileprivate var selectedArtistResult: DiscogsSearchResult? {
        if let indexPath = searchView?.tableView?.indexPathForSelectedRow {
            return searchResultsModel?.results?[indexPath.row]
        } else {
            return nil
        }
    }

}
