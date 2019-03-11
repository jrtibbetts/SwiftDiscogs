//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// The model for the `DiscogsSearchResultsViewController`.
open class DiscogsSearchResultsModel: CollectionAndTableModel {

    // MARK: - Properties

    open var results: [SearchResult]?

    // MARK: - UITableViewDataSource

    open override func numberOfItems(inSection section: Int) -> Int {
        if let results = results, section == 0 {
            return results.count
        } else {
            return 0
        }
    }

    open override func numberOfSections() -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView,
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
