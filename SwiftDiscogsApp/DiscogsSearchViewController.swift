//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

class DiscogsSearchViewController: UIViewController, UISearchControllerDelegate {

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

    func setUpSearchController() {
        // Load the search results controller from the storyboard.
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle:  bundle)
        searchResultsController = storyboard.instantiateViewController(withIdentifier: "searchResults") as! DiscogsSearchResultsController
        searchResultsController.navigationItem.searchController = searchController
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = searchResultsController
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
    }

}

