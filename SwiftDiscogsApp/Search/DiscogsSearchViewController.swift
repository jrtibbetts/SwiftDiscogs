//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import SwiftDiscogs
import UIKit

/// Allows the user to search the Discogs database for artists, releases, and
/// labels.
class DiscogsSearchViewController: CollectionAndTableViewController,
                                   UISearchResultsUpdating,
                                   DiscogsProvider {

    // MARK: Public Properties

    /// The Discogs client.
    var discogs: Discogs? = /* MockDiscogs() */ DiscogsClient.singleton

    /// The search results. Changes trigger a reloading of the table and/or
    /// collection.
    var results: [SearchResult]? {
        didSet {
            searchResultsModel?.results = results
            display?.refresh()
        }
    }

    /// The data model that holds the search results.
    var searchResultsModel: DiscogsSearchResultsModel? {
        return model as? DiscogsSearchResultsModel
    }

    /// The object responsible for managing the on-screen contents of the
    /// Discogs search, which helps keep the size of this view controller down.
    /// The root view in the storyboard MUST have `DiscogsSearchView` as its
    /// custom class!
    var searchView: DiscogsSearchView? {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            case "showSelectedArtist":
                if let artistViewController = segue.destination as? DiscogsArtistViewController {
                    artistViewController.artistSearchResult = selectedArtistResult
                }
            default:
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        model = DiscogsSearchResultsModel()
        searchView?.model = model
        searchView?.setUp(navigationItem: navigationItem)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let discogs = discogs, !discogs.isSignedIn {
            performSegue(withIdentifier: "showSignIn", sender: self)
        }
    }

    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerms = searchController.searchBar.text,
            !searchTerms.replacingOccurrences(of: " ", with: "").isEmpty else {
                results = nil
                return
        }

        discogs?.search(for: searchTerms, type: "Artist").done { [weak self] (searchResults) in
            guard let self = self else {
                return
            }

            self.results = searchResults.results?.filter { $0.type == "artist" }

            if self.results?.count == 1 {
                self.searchView?.selectItem(at: IndexPath(item: 0, section: 0))
            }

            }.catch { [weak self] (error) in
                self?.results = nil
                self?.presentAlert(for: error)
        }
    }

    // MARK: Everything Else

    private var selectedArtistResult: SearchResult? {
        if let indexPath = searchView?.indexPathForSelectedItem {
            return searchResultsModel?.result(at: indexPath)
        } else {
            return nil
        }
    }

}
