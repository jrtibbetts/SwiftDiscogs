//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: CollectionAndTableViewController<DiscogsArtist> {

    /// The artist in question.
    open var artist: DiscogsArtist?

    // MARK: UIViewController

    open override func viewDidLoad() {
        // Set the model and display *before* calling super, because super is
        // where the model gets assigned to the display.
        display = view as? DiscogsArtistView
        model = DiscogsArtistModel(artist: artist)
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// (Re-)set the artist model when the view controller reaches the top of
        /// the navigation stack.
        display?.model?.data = artist
    }

}
