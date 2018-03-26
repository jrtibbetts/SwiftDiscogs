//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsSublabel: Codable, Unique {

    public var identifier: Int
    public var name: String
    public var resourceUrl: String

    fileprivate enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case resourceUrl = "resource_url"
    }

}
