//  Copyright © 2017 Poikile Creations. All rights reserved.

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
    public var numberForSale: Int
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

    private enum CodingKeys: String, CodingKey {
        case artists
        case community
        case companies
        case country
        case dataQuality
        case dateAdded
        case dateChanged
        case estimatedWeight
        case extraArtists
        case formatQuantity
        case formats
        case genres
        case id
        case identifiers
        case images
        case labels
        case lowestPrice
        case masterId
        case masterUrl
        case notes
        case numberForSale = "numForSale"
        case released
        case releasedFormatted
        case resourceUrl
        case series
        case status
        case styles
        case thumb
        case title
        case tracklist
        case uri
        case videos
        case year

    }

}
