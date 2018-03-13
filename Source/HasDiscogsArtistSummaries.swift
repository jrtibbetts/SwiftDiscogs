//  Copyright © 2018 nrith. All rights reserved.

import Foundation

public protocol HasDiscogsArtistSummaries {

    var artists: [DiscogsArtistSummary]? { get set }

}

extension HasDiscogsArtistSummaries {

    public var artistString: String {
        if let artists = artists {
            var artistNameString = ""
            artists.forEach({ (artist) in
                artistNameString.append("\(artist.name)")

                if let join = artist.join, join != "," {
                    artistNameString.append(" \(join) ")
                }
            })

            return artistNameString
        } else {
            return "Unknown Artist"
        }
    }

}
