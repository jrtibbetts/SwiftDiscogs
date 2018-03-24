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
    public var identifiers: [DiscogsReleaseIdentifier]?
    public var images: [DiscogsImage]?
    public var identifier: Int
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

    fileprivate enum CodingKeys: String, CodingKey {
        case artists
        case community
        case companies
        case country
        case dataQuality = "data_quality"
        case dateAdded = "date_added"
        case dateChanged = "date_changed"
        case estimatedWeight = "estimated_weight"
        case extraArtists = "extraartists"
        case formatQuantity = "format_quantity"
        case formats
        case genres
        case identifier = "id"
        case identifiers = "ids"
        case images
        case labels
        case lowestPrice = "lowest_price"
        case masterId = "master_id"
        case masterUrl = "master_url"
        case notes
        case numberForSale = "num_for_sale"
        case released
        case releasedFormatted = "released_formatted"
        case resourceUrl = "resource_url"
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

public struct DiscogsReleaseCommunity: Codable {

    public var contributors: [DiscogsReleaseContributor]
    public var dataQuality: String?
    public var have: Int
    public var status: String?
    public var submitter: DiscogsReleaseContributor?
    public var want: Int

    fileprivate enum CodingKeys: String, CodingKey {
        case contributors
        case dataQuality = "data_quality"
        case have
        case status
        case submitter
        case want
    }

}

public struct DiscogsReleaseContributor: Codable {

    public var resourceUrl: String
    public var username: String

    fileprivate enum CodingKeys: String, CodingKey {
        case resourceUrl = "resource_url"
        case username
    }

}

public struct DiscogsReleaseFormat: Codable {

    public var count: String
    public var descriptions: [String]?
    public var name: String

    fileprivate enum CodingKeys: String, CodingKey {
        case count = "qty"
        case descriptions
        case name
    }
}

public struct DiscogsReleaseIdentifier: Codable {

    public var type: String
    public var value: String?

}

public struct DiscogsReleaseLabel: Codable, Unique {

    public var catalogNumber: String?
    public var entityType: String
    public var identifier: Int
    public var name: String
    public var resourceUrl: String

    fileprivate enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case entityType = "entity_type"
        case identifier = "id"
        case name
        case resourceUrl = "resource_url"
    }

}

public struct DiscogsReleaseRating: Codable {
    public var average: Float
    public var count: Int
}
