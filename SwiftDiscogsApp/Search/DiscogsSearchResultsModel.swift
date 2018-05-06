//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// The model for the `DiscogsSearchResultsViewController`.
open class DiscogsSearchResultsModel: CollectionAndTableModel {

    // MARK: Properties

    open var results: [DiscogsSearchResult]?

    // MARK: Initializers

    /// An empty initializer seems to be required when the class is set as a
    /// custom object in a storyboard.
    override public init() {
        super.init()
    }

    public init(results: [DiscogsSearchResult]? = nil) {
        self.results = results
        super.init()
    }

    // MARK: UITableViewDataSource

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
            cell.artistName = result?.title
            
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

}
