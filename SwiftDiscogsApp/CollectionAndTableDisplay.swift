//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `UIView` that has outlets to an embedded collection view and table view,
/// only one of which is displayed at a given time, depending on screen
/// orientation and size.
open class CollectionAndTableDisplay: Display {

    // MARK: Outlets

    /// The `UICollectionView` that's contained in this view.
    @IBOutlet open var collectionView: UICollectionView?

    /// The `UITableView` that's contained in this view.
    @IBOutlet open var tableView: UITableView?
    
    // MARK: Functions
    
    /// Reload the data in the collection and table views. Subclasses should
    /// override this to update their models, and then call this superclass
    /// method.
    override open func refresh() {
        super.refresh()
        
        collectionView?.reloadData()
        tableView?.reloadData()
    }

}
