//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: CollectionAndTableViewController<DiscogsArtist> {

    /// The artist in question.
    open var artist: DiscogsArtist?

    /// (Re-)set the artist model when the view controller reaches the top of
    /// the navigation stack.
    ///
    /// - parameter animated: `true` if the view was animated in, as opposed
    ///             to being shown instantly.
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let artist = artist {
            let model = DiscogsArtistModel(artist: artist)
            display?.model = model
        }
    }

}
