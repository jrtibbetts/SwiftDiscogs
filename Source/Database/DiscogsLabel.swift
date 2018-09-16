//  Copyright © 2017 Poikile Creations. All rights reserved.

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
    public var sublabels: [DiscogsSublabel]?
    public var uri: String
    public var urls: [String]?

}
