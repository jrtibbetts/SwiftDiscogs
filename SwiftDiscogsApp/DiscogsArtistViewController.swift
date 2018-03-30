//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: UIViewController {

    /// The artist in question.
    open var artist: DiscogsArtist?

    /// The user interface. All UI elements are contained and handled there.
    /// Note that it's not an `IBOutlet`, since we already have an outlet to
    /// the view.
    open var artistView: DiscogsArtistView? {
        return view as? DiscogsArtistView
    }

    /// (Re-)set the artist model when the view controller reaches the top of
    /// the navigation stack.
    ///
    /// - parameter animated: `true` if the view was animated in, as opposed
    ///             to being shown instantly.
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let artist = artist {
            artistView?.model = DiscogsArtistModel(artist: artist)
        }
    }

}

/// The user interface for the `DiscogsArtistViewController`. It has outlets
/// for a table view and a collection view, even though only one will be
/// active at a time, depending on the device's orientation.
open class DiscogsArtistView: UIView {

    /// The artist model.
    open var model: DiscogsArtistModel? {
        didSet {
            reload()
        }
    }

    // MARK: - Outlets

    /// The table view. This should be non-`nil` when the device is in
    /// compact-width mode.
    @IBOutlet weak var tableView: UITableView? {
        didSet {
            reload()
        }
    }

    /// The collection view. This should be non-`nil` when the device is in
    /// regular-width mode.
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            reload()
        }
    }

    // MARK: - Other Functions

    /// Reload the table or collection view, as appropriate.
    open func reload() {
        if let tableView = tableView {
            tableView.dataSource = model
            tableView.delegate = model
            tableView.reloadData()
        }

        if let collectionView = collectionView {
//            collectionView.dataSource = model
//            collectionview.delegate = model
            collectionView.reloadData()
        }
    }

}
