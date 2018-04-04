//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsRelease: Codable, HasDiscogsArtistSummaries, Unique {

    public var artists: [DiscogsArtistSummary]?
    public var community: DiscogsReleaseCommunity?
    public var companies: [DiscogsReleaseLabel]?
    public var country: String?
    public var dataQuality: String?
    public var dateAdded: String?
    public var dateChanged: String?
    public var estimatedWeight: Int
    public var extraArtists: [DiscogsArtistSummary]?
    public var formatQuantity: Int?
    public var formats: [DiscogsReleaseFormat]?
    public var genres: [String]?
    public var id: Int
    public var identifiers: [DiscogsReleaseIdentifier]?
    public var images: [DiscogsImage]?
    public var labels: [DiscogsReleaseLabel]?
    public var lowestPrice: Float?
    public var masterId: Int
    public var masterUrl: String
    public var notes: String?
    public var numForSale: Int
    public var numberForSale: Int { return numForSale }
    public var released: String?
    public var releasedFormatted: String?
    public var resourceUrl: String
    public var series: [String]?
    public var status: String?
    public var styles: [String]?
    public var thumb: String?
    public var title: String
    public var tracklist: [DiscogsTrack]
    public var uri: String
    public var videos: [DiscogsVideo]?
    public var year: Int?

}
