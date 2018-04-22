//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

open class DiscogsSearchResultsController: Controller, UISearchResultsUpdating, DiscogsProvider {

    // MARK: Properties

    /// The Discogs client. By default, this is the singleton instance of
    /// `DiscogsClient`, but it can be changed, which can be useful for
    /// testing.
    open var discogs: Discogs? = DiscogsClient.singleton

    /// The (usually) root view of the view controller, which you MUST set in
    /// the storyboard as this specific type!
    open var searchResultsView: DiscogsSearchResultsView? {
        return view as? DiscogsSearchResultsView
    }

    /// The data model that holds the search results.
    open var searchResultsModel: DiscogsSearchResultsModel? {
        return model as? DiscogsSearchResultsModel
    }

    /// The search results. Changes trigger a reloading of the table and/or
    /// collection.
    open var results: [DiscogsSearchResult]? {
        didSet {
            searchResultsModel?.results = results
            display.refresh()
        }
    }

    // MARK: UISearchResultsUpdating
    
    open func updateSearchResults(for searchController: UISearchController) {
        let searchTerms = searchController.searchBar.text ?? ""
        let promise: Promise<DiscogsSearchResults>? = discogs?.search(for: searchTerms, type: "Artist")
        promise?.then { [weak self] (searchResults) -> Void in
            self?.results = searchResults.results?.filter({ $0.type == "artist" })
            }.catch { [weak self] (error) in
                self?.results = nil
                self?.presentAlert(for: error)
        }
    }
    
}
