//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseLabel: Codable, Unique {

    public var catalogNumber: String?
    public var entityType: String
    public var id: Int
    public var name: String
    public var resourceUrl: String

    private enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case entityType
        case id
        case name
        case resourceUrl
    }
}
