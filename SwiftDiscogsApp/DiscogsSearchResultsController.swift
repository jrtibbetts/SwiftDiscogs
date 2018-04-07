//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

open class DiscogsSearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    open var results: [DiscogsSearchResult] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    fileprivate var pendingPromise: Promise<DiscogsSearchResults>?
    
    // MARK: - UISearchResultsUpdating
    
    open func updateSearchResults(for searchController: UISearchController) {
        let searchTerms = searchController.searchBar.text ?? ""
        let promise: Promise<DiscogsSearchResults>?
            = DiscogsClient.singleton?.search(for: searchTerms, type: "Artist")
        promise?.then { [weak self] (searchResults) -> Void in
            guard let filteredResults = searchResults.results?.filter({ $0.type == "artist" }) else {
                self?.results = []
                return
            }
            self?.results = filteredResults
            }.catch { [weak self] (error) in
                print("Error: \(error.localizedDescription)")
                self?.results = []
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override open func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = results[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchResultCell",
                                                    for: indexPath) as? ArtistSearchResultCell {
            cell.nameLabel?.text = artist.title
            
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
}

open class ArtistSearchResultCell: UITableViewCell {
    
    @IBOutlet weak var detailsLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var thumbnailView: UIImageView?
    
}