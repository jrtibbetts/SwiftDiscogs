//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsBandMember: Codable, Unique {

    public var active: Bool?
    public var identifier: Int
    public var name: String
    public var resourceUrl: String

    private enum CodingKeys: String, CodingKey {
        case active
        case identifier = "id"
        case name
        case resourceUrl = "resource_url"
    }

}
