//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsArtistSummary: Codable, Unique {

    public var nameVariation: String?
    public var id: Int
    public var join: String?
    public var name: String
    public var resourceUrl: URL
    public var role: String
    public var tracks: String?

    private enum CodingKeys: String, CodingKey {
        case nameVariation = "anv"
        case id
        case join
        case name
        case resourceUrl = "resource_url"
        case role
        case tracks
    }

}
