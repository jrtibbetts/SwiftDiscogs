//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable nesting
// swiftlint:disable identifier_name

public struct CollectionFolderItems: Codable, Pageable {

    public var pagination: Pagination?
    public var releases: [CollectionFolderItem]?

}

public struct CollectionFolderItem: Codable {

    public var folderId: Int
    public var id: Int
    public var basicInformation: Info?
    public var instanceId: Int
    public var notes: [Note]?
    public var rating: Int

    public struct Info: Codable, HasArtistSummaries, Unique {

        public var artists: [ArtistSummary]?
        public var coverImage: String?
        public var formats: [Format]?
        public var id: Int
        public var labels: [Label]?
        public var resourceUrl: String
        public var thumb: String?
        public var title: String
        public var year: Int?

    }

    public struct Format: Codable {

        public var descriptions: [String]?
        public var name: String?
        public var quantity: String?
        public var text: String?

        private enum CodingKeys: String, CodingKey {
            case descriptions
            case name
            case quantity = "qty"
            case text
        }
    }

    public struct Label: Codable, Unique {

        public var catalogNumber: String?
        public var entityType: String?
        public var entityTypeName: String?
        public var id: Int
        public var name: String
        public var resourceUrl: String

        private enum CodingKeys: String, CodingKey {
            case catalogNumber = "catno"
            case entityType
            case entityTypeName
            case id
            case name
            case resourceUrl
        }

    }

    public struct Note: Codable {

        public var fieldId: Int
        public var value: String

    }

}

// swiftlint:enable nesting
// swiftlint:enable identifier_name
