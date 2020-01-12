//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

/// A JSON element that contains the folders array.
public struct CollectionFolders: Codable {

    public var folders: [CollectionFolder]

}

/// Information about a folder in a user's collection.
public struct CollectionFolder: Codable, Unique {

    public var id: Int
    public var count: Int
    public var name: String
    public var resourceUrl: String

}

// swiftlint:enable identifier_name
