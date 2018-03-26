//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseLabel: Codable, Unique {

    public var catalogNumber: String?
    public var entityType: String
    public var identifier: Int
    public var name: String
    public var resourceUrl: String

    fileprivate enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case entityType = "entity_type"
        case identifier = "id"
        case name
        case resourceUrl = "resource_url"
    }

}
