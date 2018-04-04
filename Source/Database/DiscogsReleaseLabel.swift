//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseLabel: Codable, Unique {

    public var catno: String?
    public var catalogNumber: String? { return catno }
    public var entityType: String
    public var id: Int
    public var name: String
    public var resourceUrl: String

}
