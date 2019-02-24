//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseFormat: Codable {

    public var count: String
    public var descriptions: [String]?
    public var name: String

    private enum CodingKeys: String, CodingKey {
        case count = "qty"
        case descriptions
        case name
    }

}
