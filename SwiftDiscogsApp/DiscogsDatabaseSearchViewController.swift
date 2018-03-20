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
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerms = searchBar.text, searchTerms.count > 5 {
            let promise: Promise<DiscogsSearchResults> = DiscogsClient.singleton.search(for: searchTerms, type: "")
            promise.then { (searchResults) -> Void in
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
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
    }

}

