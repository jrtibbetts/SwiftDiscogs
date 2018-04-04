//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseFormat: Codable {

    public var count: String { return qty }
    public var descriptions: [String]?
    public var name: String
    public var qty: String

}
