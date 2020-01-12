//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

public struct ArtistSummary: Codable, Unique {

    public var artistNameVariation: String?
    public var id: Int
    public var join: String?
    public var name: String
    public var resourceUrl: String
    public var role: String
    public var tracks: String?

    private enum CodingKeys: String, CodingKey {
        case artistNameVariation = "anv"
        case id
        case join
        case name
        case resourceUrl
        case role
        case tracks
    }

}

// swiftlint:enable identifier_name
