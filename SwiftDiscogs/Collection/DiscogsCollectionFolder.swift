//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionFolders: Codable {

    public var folders: [DiscogsCollectionFolder]

}

public struct DiscogsCollectionFolder: Codable, Unique {

    private enum CodingKeys: String, CodingKey {
        case id
        case count
        case name
        case resourceUrl = "resource_url"
    }

    public var id: Int
    public var count: Int
    public var name: String
    public var resourceUrl: String

}
