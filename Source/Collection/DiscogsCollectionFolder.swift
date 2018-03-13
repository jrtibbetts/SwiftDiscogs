//  Copyright © 2017 nrith. All rights reserved.

import Foundation

/// A JSON element that contains the folders array.
public struct DiscogsCollectionFolders: Codable {

    public var folders: [DiscogsCollectionFolder]

}

/// Information about a folder in a user's collection.
public struct DiscogsCollectionFolder: Codable, Unique {

    public var id: Int
    public var count: Int
    public var name: String
    public var resourceUrl: URL

    private enum CodingKeys: String, CodingKey {
        case id
        case count
        case name
        case resourceUrl = "resource_url"
    }

}
