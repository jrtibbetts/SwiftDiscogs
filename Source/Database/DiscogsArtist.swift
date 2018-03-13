//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsArtist: Codable, Unique {

    public struct BandMember: Codable, Unique {

        private enum CodingKeys: String, CodingKey {
            case active
            case id
            case name
            case resourceUrl = "resource_url"
        }

        public var active: Bool?
        public var id: Int
        public var name: String
        public var resourceUrl: String

    }

    private enum CodingKeys: String, CodingKey {
        case dataQuality = "data_quality"
        case id
        case images
        case members
        case nameVariations = "namevariations"
        case profile
        case releasesUrl = "releases_url"
        case resourceUrl = "resource_url"
        case urls
    }

    public var dataQuality: String?
    public var id: Int
    public var images: [DiscogsImage]?
    public var members: [BandMember]?
    public var nameVariations: [String]?
    public var profile: String?
    public var releasesUrl: String
    public var resourceUrl: String
    public var urls: [String]?

}
