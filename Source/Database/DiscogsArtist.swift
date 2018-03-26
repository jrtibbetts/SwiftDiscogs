//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsArtist: Codable, Unique {

    public var dataQuality: String?
    public var identifier: Int
    public var images: [DiscogsImage]?
    public var members: [DiscogsBandMember]?
    public var name: String?
    public var nameVariations: [String]?
    public var profile: String?
    public var releasesUrl: URL
    public var resourceUrl: String
    public var urls: [String]?

    private enum CodingKeys: String, CodingKey {
        case dataQuality = "data_quality"
        case identifier = "id"
        case images
        case members
        case name
        case nameVariations = "namevariations"
        case profile
        case releasesUrl = "releases_url"
        case resourceUrl = "resource_url"
        case urls
    }

}
