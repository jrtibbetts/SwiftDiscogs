//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `UIView` that has outlets to an embedded collection view and table view,
/// only one of which is displayed at a given time, depending on screen
/// orientation and size. They can be switched by calling
/// `toggleForegroundView()` or by setting the `foregroundMode` explicitly.
open class CollectionAndTableDisplay: Display, UICollectionViewDelegate, UITableViewDelegate {

    /// The possible modes for the foreground view. They should be pretty
    /// self-explanatory.
    public enum ForegroundMode: Int {

        /// Mode where the collection view is shown and the table view is
        /// hidden.
        case collection = 0

        /// Mode where the table view is shown and the collection view is
        /// hidden.
        case table

    }

    // MARK: - Public Properties

    /// The current state of the foreground view. It defaults to `.table`
    /// unless the `collectionView` is non-`nil` and the mode has been set
    /// explicitly to `.collection`.
    open var foregroundMode: ForegroundMode {
        get {
            if tableView != nil && (foregroundView == nil || foregroundView === tableView) {
                return .table
            } else if collectionView != nil {
                return .collection
            } else {
                return .table
            }
        }

        set {
            if foregroundMode != newValue {
                switch newValue {
                case .table:
                    foregroundView = tableView       // triggers a show/hide
                case .collection:
                    foregroundView = collectionView  // triggers a show/hide
                }
            }
        }
    }

    /// The foreground view, depending on the current mode. Setting it (which
    /// can only be done internally) causes the former foreground view to be
    /// hidden and the new one to be shown.
    open private(set) var foregroundView: UIView? {
        didSet {
            if let foregroundView = foregroundView {
                if let oldValue = oldValue {
                    banish(oldValue)
                }

                summon(foregroundView)
            }
        }
    }

    /// Get the currently-selected item for the foreground view.
    open var indexPathForSelectedItem: IndexPath? {
        switch foregroundMode {
        case .collection where collectionView != nil:
            return collectionView?.indexPathsForSelectedItems?.first
        case .table where tableView != nil:
            return tableView?.indexPathForSelectedRow
        default:
            return nil
        }
    }

    /// Get the currently-selected items for the foreground view.
    open var indexPathsForSelectedItems: [IndexPath]? {
        switch foregroundMode {
        case .collection where collectionView != nil:
            return collectionView?.indexPathsForSelectedItems
        case .table where tableView != nil:
            return tableView?.indexPathsForSelectedRows
        default:
            return nil
        }
    }

    open var model: CollectionAndTableModel? {
        didSet {
            tableView?.dataSource = model
            collectionView?.dataSource = model
        }
    }

    // MARK: - Outlets

    /// The `UICollectionView` that's contained in this view.
    @IBOutlet open weak var collectionView: UICollectionView? {
        didSet {
            guard let collectionView = collectionView else {
                return
            }

            collectionView.delegate = self

            if foregroundView == nil {
                foregroundView = collectionView
            }
        }
    }

    /// The `UITableView` that's contained in this view.
    @IBOutlet open weak var tableView: UITableView? {
        didSet {
            guard let tableView = tableView else {
                return
            }

            // Unlike the collectionView's didSet(), setting the tableView to
            // non-nil ALWAYS puts it in the foreground.
            tableView.delegate = self
            foregroundView = tableView
        }
    }

    // MARK: - Display

    /// Reload the data in the collection and table views. Subclasses should
    /// override this to update their models, and then call this superclass
    /// method.
    override open func refresh() {
        super.refresh()

        collectionView?.reloadData()
        tableView?.reloadData()
    }

    // MARK: - Public Functions

    open func toggleForegroundView() {
        guard let tableView = tableView, let collectionView = collectionView else {
            return
        }

        foregroundView = (tableView === foregroundView ? collectionView : tableView)
    }

}
