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

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - UISearchResultsUpdating

    public func updateSearchResults(for searchController: UISearchController) {
        if let searchTerms = searchController.searchBar.text, searchTerms.count >= 3 {
            //            let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? ""
            let promise: Promise<DiscogsSearchResults> = DiscogsClient.singleton.search(for: searchTerms, type: "Artist")
            promise.then { [weak self] (searchResults) -> Void in
                if let results = searchResults.results {
                    self?.results = results.filter { $0.type == "artist" }
                }
                }.catch { (error) in
                    print("Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchResultCell", for: indexPath) as! ArtistSearchResultCell

        cell.nameLabel?.text = artist.title

        return cell
    }

}

open class ArtistSearchResultCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?

}
