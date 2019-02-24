//  Copyright © 2017 Poikile Creations. All rights reserved.

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
        case dataQuality
        case genres
        case id
        case images
        case lowestPrice
        case mainRelease
        case mainReleaseUrl
        case numberForSale = "numForSale"
        case resourceUrl
        case styles
        case title
        case tracklist
        case uri
        case versionsUrl
        case videos
        case year
    }

}
