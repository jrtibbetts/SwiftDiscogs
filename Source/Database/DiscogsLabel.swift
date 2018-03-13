//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsLabel: Codable, Unique {

    public var contactInfo: String?
    public var dataQuality: String?
    public var id: Int
    public var images: [DiscogsImage]?
    public var name: String
    public var profile: String?
    public var releasesUrl: URL
    public var resourceUrl: String
    public var sublabels: [Sublabel]?
    public var uri: String
    public var urls: [String]?

    private enum CodingKeys: String, CodingKey {
        case contactInfo = "contact_info"
        case dataQuality = "data_quality"
        case id
        case images
        case name
        case profile
        case releasesUrl = "releases_url"
        case resourceUrl = "resource_url"
        case sublabels
        case uri
        case urls
    }

    public struct Sublabel: Codable, Unique {

        public var id: Int
        public var name: String
        public var resourceUrl: String

        fileprivate enum CodingKeys: String, CodingKey {
            case id
            case name
            case resourceUrl = "resource_url"
        }

    }

}
