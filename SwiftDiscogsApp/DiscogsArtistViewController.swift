//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: UIViewController {

    /// The artist in question.
    open var artist: DiscogsArtist?

    @IBOutlet open weak var tableView: UITableView?

    @IBOutlet open weak var collectionView: UICollectionView?

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
            let model = DiscogsArtistModel(artist: artist)
            artistView?.model = model
            tableView?.delegate = model
            tableView?.dataSource = model
            collectionView?.delegate = model
            collectionView?.dataSource = model
        }
    }

}
