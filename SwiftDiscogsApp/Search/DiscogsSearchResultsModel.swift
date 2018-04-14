//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

open class DiscogsSearchResultsModel: CollectionAndTableArrayModel<DiscogsSearchResult> {
    
    // MARK: UITableViewDataSource
    
    override open func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = data?[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchResultCell",
                                                    for: indexPath) as? ArtistSearchResultCell {
            cell.artistName = result?.title
            
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
}
