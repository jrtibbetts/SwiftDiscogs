//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
open class DiscogsArtistViewController: OutlettedController {

    // MARK: Public Properties

    /// The Discogs client. By default, this is the singleton instance of
    /// `DiscogsClient`, but it can be changed, which can be useful for
    /// testing.
    open var discogs: Discogs? = DiscogsClient.singleton

    /// The artist in question.
    open var artist: Artist? {
        didSet {
            artistModel?.artist = artist
            display?.refresh()

            // Now go get the artist's release summaries.
            fetchReleases()
        }
    }

    open var artistSearchResult: SearchResult? {
        didSet {
            if let artistId = artistSearchResult?.id {
                discogs?.artist(identifier: artistId).done { (artist) in
                    self.artist = artist
                    }.catch { (error) in
                        // HANDLE THE ERROR
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

    // MARK: Private Functions

    fileprivate func fetchReleases() {
        if let artistId = artist?.id {
            discogs?.releases(forArtist: artistId).done { [weak self] (summaries) in
                self?.artistModel?.releases = summaries.releases?.filter { $0.type == "master" && $0.mainRelease != nil }
                self?.display?.refresh()
                }.catch { (error) in
                    // HANDLE THE ERROR
            }
        }
    }
}
