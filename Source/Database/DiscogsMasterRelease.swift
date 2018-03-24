//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsMasterRelease: Codable, Unique {

    public var artists: [DiscogsArtistSummary]
    public var dataQuality: String
    public var genres: [String]
    public var identifier: Int
    public var images: [DiscogsImage]?
    public var lowestPrice: Float
    public var mainReleaseId: Int
    public var mainReleaseUrl: String
    public var numberForSale: Int
    public var resourceUrl: String
    public var styles: [String]
    public var title: String
    public var tracklist: [DiscogsTrack]
    public var uri: String
    public var versionsUrl: String
    public var videos: [DiscogsVideo]?
    public var year: Int

    private enum CodingKeys: String, CodingKey {
        case artists
        case dataQuality = "data_quality"
        case genres
        case identifier = "id"
        case images
        case lowestPrice = "lowest_price"
        case mainReleaseId = "main_release"
        case mainReleaseUrl = "main_release_url"
        case numberForSale = "num_for_sale"
        case resourceUrl = "resource_url"
        case styles
        case title
        case tracklist
        case uri
        case versionsUrl = "versions_url"
        case videos
        case year
    }

}

public struct DiscogsMasterReleaseVersion: Codable, Unique {

    public var catalogNumber: String?
    public var country: String?
    public var formats: [String]?
    public var identifier: Int
    public var label: String?
    public var majorFormats: [String]?
    public var released: String?
    public var resourceUrl: String
    public var status: String?
    public var thumb: String?
    public var title: String

    private enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case country
        case formats
        case identifier = "id"
        case label
        case majorFormats = "major_formats"
        case released
        case resourceUrl = "resource_url"
        case status
        case thumb
        case title
    }

}

public struct DiscogsMasterReleaseVersions: Codable, Pageable {

    public var pagination: DiscogsPagination?
    public var versions: [DiscogsMasterReleaseVersion]

}
