//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import SwiftDiscogs
import UIKit

/// Allows the user to search the Discogs database for artists, releases, and
/// labels.
open class DiscogsSearchViewController: CollectionAndTableViewController, UISearchResultsUpdating, UISearchBarDelegate, DiscogsProvider {

    /// The possible states of the search scope bar.
    public enum SearchScope: Int {
        /// Search the entire database
        case allOfDiscogs

        /// Search only within the user's own collection
        case userCollection
    }

    // MARK: Public Properties

    /// The Discogs client.
    open var discogs: Discogs? = /* MockDiscogs() */ DiscogsClient.singleton

    /// The search results. Changes trigger a reloading of the table and/or
    /// collection.
    open var results: [SearchResult]? {
        didSet {
            searchResultsModel?.results = results
            display?.refresh()
        }
    }

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

    // MARK: - Private Properties

    /// The `UISearchController`. It displays its results here, not in a
    /// separate results controller.
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        return searchController
    }()

    // MARK: - Actions

    @IBAction private func signOut() {
        discogs?.signOut()
    }

    // MARK: - Functions

    public func search(forArtistNamed artistName: String) {
        searchController.searchBar.text = artistName
    }
    
    // MARK: UIViewController

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            case "showArtist":
                if let artistViewController = segue.destination as? DiscogsArtistViewController {
                    artistViewController.artistSearchResult = selectedArtistResult
                }
            default:
                return
            }
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        model = DiscogsSearchResultsModel()
        searchView?.model = model
        searchView?.setUp(navigationItem: navigationItem)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let discogs = discogs, !discogs.isSignedIn {
            performSegue(withIdentifier: "showSignIn", sender: self)
        }
    }

    // MARK: UISearchResultsUpdating

    open func updateSearchResults(for searchController: UISearchController) {
        if let searchTerms = searchController.searchBar.text, !searchTerms.replacingOccurrences(of: " ", with: "").isEmpty {
            let promise: Promise<SearchResults>? = discogs?.search(for: searchTerms, type: "Artist")
            promise?.done { [weak self] (searchResults) in
                self?.results = searchResults.results?.filter { $0.type == "artist" }
                }.catch { [weak self] (error) in
                    self?.results = nil
                    self?.presentAlert(for: error)
            }
        } else {
            results = nil
        }
    }

    // MARK: Everything Else

    fileprivate var selectedArtistResult: SearchResult? {
        if let indexPath = searchView?.indexPathForSelectedItem {
            return searchResultsModel?.results?[indexPath.row]
        } else {
            return nil
        }
    }

}
