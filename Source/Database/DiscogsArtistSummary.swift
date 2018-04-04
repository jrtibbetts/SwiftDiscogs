//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsArtistSummary: Codable, Unique {

    public var anv: String?
    public var artistNameVariation: String? { return anv }
    public var id: Int
    public var join: String?
    public var name: String
    public var resourceUrl: String
    public var role: String
    public var tracks: String?

}
