//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `UIView` that has outlets to an embedded collection view and table view,
/// only one of which is displayed at a given time, depending on screen
/// orientation and size.
open class CollectionAndTableDisplay: UIView {

    // MARK: Outlets

    /// The `UICollectionView` that's contained in this view.
    @IBOutlet open weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = model
            collectionView?.delegate = model
        }
    }

    /// The `UITableView` that's contained in this view.
    @IBOutlet open weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = model
            tableView?.delegate = model
        }
    }

    // MARK: Other Properties

    open var model: CollectionAndTableModel? {
        didSet {
            collectionView?.dataSource = model
            collectionView?.delegate = model
            tableView?.dataSource = model
            tableView?.delegate = model
        }
    }

    // MARK: Functions
    
    /// Reload the data in the collection and table views. Subclasses should
    /// override this to update their models, and then call this superclass
    /// method.
    open func refresh() {
        collectionView?.reloadData()
        tableView?.reloadData()
    }

}
