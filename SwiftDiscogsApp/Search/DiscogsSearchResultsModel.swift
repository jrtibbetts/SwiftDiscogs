//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

open class DiscogsSearchResultsModel: CollectionAndTableArrayModel<DiscogsSearchResult> {

    open var results: [DiscogsSearchResult]? {
        didSet {
            super.data = results
        }
    }

    public init(results: [DiscogsSearchResult]?) {
        super.init(data: results)
        self.results = results
    }

    // MARK: UITableViewDataSource

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
