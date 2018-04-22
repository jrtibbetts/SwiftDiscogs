//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: Controller {

    /// The artist in question.
    open var artist: DiscogsArtist?

    open var artistView: DiscogsArtistView? {
        return view as? DiscogsArtistView
    }

    open var artistModel: DiscogsArtistModel? {
        return model as? DiscogsArtistModel
    }

    // MARK: UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// (Re-)set the artist model when the view controller reaches the top of
        /// the navigation stack.
        artistModel?.artist = artist
        display.refresh()
    }

}
