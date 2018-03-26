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
