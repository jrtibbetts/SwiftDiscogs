//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// The model for the `DiscogsSearchResultsViewController`.
class DiscogsSearchResultsModel: CollectionAndTableModel {

    // MARK: - Properties

    var results: [SearchResult]?

    func result(at index: IndexPath) -> SearchResult? {
        return results?[index.item]
    }

    // MARK: - UITableViewDataSource

    override func numberOfItems(inSection section: Int) -> Int {
        if let results = results, section == 0 {
            return results.count
        } else {
            return 0
        }
    }

    override func numberOfSections() -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results?[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchResultCell",
                                                    for: indexPath) as? ArtistSearchResultCell {
            cell.searchResult = result
            
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }    

}
