//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: Controller {

    // MARK: Public Properties

    /// The Discogs client. By default, this is the singleton instance of
    /// `DiscogsClient`, but it can be changed, which can be useful for
    /// testing.
    open var discogs: Discogs? = DiscogsClient.singleton

    /// The artist in question.
    open var artist: DiscogsArtist? {
        didSet {
            artistModel?.artist = artist
            display?.refresh()

            // Now go get the artist's release summaries.
            fetchReleases()
        }
    }

    open var artistSearchResult: DiscogsSearchResult? {
        didSet {
            if let artistId = artistSearchResult?.id {
                discogs?.artist(identifier: artistId).then { (artist) -> Void in
                    self.artist = artist
                }
            }
        }
    }

    open var artistView: DiscogsArtistView? {
        return view as? DiscogsArtistView
    }

    open var artistModel: DiscogsArtistModel? {
        return model as? DiscogsArtistModel
    }

    // MARK: Actions

    @IBAction fileprivate func close() {
        dismiss(animated: true)
    }

    // MARK: UIViewController

//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        /// (Re-)set the artist model when the view controller reaches the top of
//        /// the navigation stack.
//        artistModel?.artist = artist
//        display.refresh()
//    }

    // MARK: Private Functions

    fileprivate func fetchReleases() {
        if let artistId = artist?.id {
            discogs?.releases(forArtist: artistId).then { [weak self] (summaries) -> Void in
                self?.artistModel?.releases = summaries.releases
                self?.display?.refresh()
            }
        }
    }
}
