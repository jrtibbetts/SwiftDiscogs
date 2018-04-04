//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsMasterRelease: Codable, Unique {

    public var artists: [DiscogsArtistSummary]
    public var dataQuality: String
    public var genres: [String]
    public var id: Int
    public var images: [DiscogsImage]?
    public var lowestPrice: Float
    public var mainRelease: Int
    public var mainReleaseUrl: String
    public var numForSale: Int
    public var numberForSale: Int { return numForSale }
    public var resourceUrl: String
    public var styles: [String]
    public var title: String
    public var tracklist: [DiscogsTrack]
    public var uri: String
    public var versionsUrl: String
    public var videos: [DiscogsVideo]?
    public var year: Int

}
