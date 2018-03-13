//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionFolderItems: Codable, Pageable {

    public var pagination: DiscogsPagination?
    public var releases: [DiscogsCollectionFolderItem]?

}

public struct DiscogsCollectionFolderItem: Codable {

    public struct BasicInformation: Codable, HasDiscogsArtistSummaries, Unique {

        public var artists: [DiscogsArtistSummary]?
        public var id: Int
        public var coverImage: String?
        public var formats: [Format]?
        public var labels: [Label]?
        public var resourceUrl: String
        public var thumb: String?
        public var title: String
        public var year: Int?

        private enum CodingKeys: String, CodingKey {
            case artists
            case id
            case coverImage = "cover_image"
            case formats
            case labels
            case resourceUrl = "resource_url"
            case thumb
            case title
            case year
        }

        public struct Format: Codable {

            public var descriptions: [String]?
            public var name: String?
            public var quantity: String?
            public var text: String?

            fileprivate enum CodingKeys: String, CodingKey {
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

            fileprivate enum CodingKeys: String, CodingKey {
                case catalogNumber = "catno"
                case entityType = "entity_type"
                case entityTypeName = "entity_type_name"
                case id
                case name
                case resourceUrl = "resource_url"
            }

        }

    }

    public struct Note: Codable {

        private enum CodingKeys: String, CodingKey {
            case fieldId = "field_id"
            case value
        }

        public var fieldId: Int
        public var value: String

    }

    private enum CodingKeys: String, CodingKey {

        case basicInformation = "basic_information"
        case folderId = "folder_id"
        case id
        case instanceId = "instance_id"
        case notes
        case rating

    }

    public var basicInformation: BasicInformation?
    public var folderId: Int
    public var id: Int
    public var instanceId: Int
    public var notes: [Note]?
    public var rating: Int

}
