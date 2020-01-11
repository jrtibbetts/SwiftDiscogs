//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public protocol HasArtistSummaries {

    var artists: [ArtistSummary]? { get set }

}

extension HasArtistSummaries {

    public var artistString: String {
        if let artists = artists {
            return artists.map { $0.name }.joined(separator: L10n.separator)
        } else {
            return L10n.unknownArtist
        }
    }

}
