//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsLabel: Codable, Unique {

    public var contactInfo: String?
    public var dataQuality: String?
    public var identifier: Int
    public var images: [DiscogsImage]?
    public var name: String
    public var profile: String?
    public var releasesUrl: URL
    public var resourceUrl: String
    public var sublabels: [DiscogsSublabel]?
    public var uri: String
    public var urls: [String]?

    private enum CodingKeys: String, CodingKey {
        case contactInfo = "contact_info"
        case dataQuality = "data_quality"
        case identifier = "id"
        case images
        case name
        case profile
        case releasesUrl = "releases_url"
        case resourceUrl = "resource_url"
        case sublabels
        case uri
        case urls
    }

}
