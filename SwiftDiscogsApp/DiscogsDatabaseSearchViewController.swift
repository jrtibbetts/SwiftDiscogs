//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

class DiscogsDatabaseSearchViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate {

    var searchController: UISearchController!

    var searchResultsController: DiscogsSearchResultsController!

    var searchBar: UISearchBar {
        return searchController.searchBar
    }

    @IBAction func signInToDiscogs() {
        let promise = DiscogsClient.singleton.authorize(presentingViewController: self,
                                                        callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise.catch { (error) in
            assertionFailure("Failed to log in")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchController()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchBar.placeholder = "Search for artists, releases, or labels"
        searchBar.scopeButtonTitles = ["All", "Releases", "Artists", "Labels"]
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerms = searchBar.text, searchTerms.count > 5 {
//            let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? ""
            let promise: Promise<DiscogsSearchResults> = DiscogsClient.singleton.search(for: searchTerms, type: "Artist")
            promise.then { (searchResults) -> Void in
                self.searchResultsController?.results = searchResults
                searchResults.results?.forEach { (result) in
                    print("Result: \(result.title)")
                }
                }.catch { (error) in
                    print("Error: \(error.localizedDescription)")
            }
        }
    }

    func setUpSearchController() {
        // Load the search results controller from the storyboard.
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle:  bundle)
        searchResultsController = storyboard.instantiateViewController(withIdentifier: "searchResults") as! DiscogsSearchResultsController
        searchResultsController.navigationItem.searchController = searchController
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
    }

}

