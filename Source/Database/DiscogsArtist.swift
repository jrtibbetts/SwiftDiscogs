//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsArtist: Codable, Unique {

    public var dataQuality: String?
    public var id: Int
    public var images: [DiscogsImage]?
    public var members: [DiscogsBandMember]?
    public var name: String?
    public var namevariations: [String]?
    public var profile: String?
    public var releasesUrl: URL
    public var resourceUrl: String
    public var urls: [String]?

}
