//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseContributor: Codable {

    public var resourceUrl: String
    public var username: String

    fileprivate enum CodingKeys: String, CodingKey {
        case resourceUrl = "resource_url"
        case username
    }

}
