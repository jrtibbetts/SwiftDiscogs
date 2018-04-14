//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

open class DiscogsSearchResultsController: CollectionAndTableViewController<[DiscogsSearchResult]>, UISearchResultsUpdating, DiscogsProvider {

    // MARK: Properties

    open var results: [DiscogsSearchResult] = [] {
        didSet {
            display?.model = DiscogsSearchResultsModel(data: results)
            display?.refresh()
        }
    }

    open var discogs: Discogs?

    // MARK: UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()
        display = view as? DiscogsSearchResultsView
    }

    // MARK: UISearchResultsUpdating
    
    open func updateSearchResults(for searchController: UISearchController) {
        let searchTerms = searchController.searchBar.text ?? ""
        let promise: Promise<DiscogsSearchResults>? = discogs?.search(for: searchTerms, type: "Artist")
        promise?.then { [weak self] (searchResults) -> Void in
            guard let filteredResults = searchResults.results?.filter({ $0.type == "artist" }) else {
                self?.results = []
                return
            }
            self?.results = filteredResults
            }.catch { [weak self] (error) in
                self?.presentAlert(for: error)
                self?.results = []
        }
    }
}
