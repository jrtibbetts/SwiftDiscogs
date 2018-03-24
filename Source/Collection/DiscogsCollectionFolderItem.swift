//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionFolderItem: Codable {

    public var basicInformation: DiscogsCollectionFolderItemInformation?
    public var folderId: Int
    public var identifier: Int
    public var instanceId: Int
    public var notes: [DiscogsCollectionFolderNote]?
    public var rating: Int

    private enum CodingKeys: String, CodingKey {

        case basicInformation = "basic_information"
        case folderId = "folder_id"
        case identifier = "id"
        case instanceId = "instance_id"
        case notes
        case rating

    }

}

public struct DiscogsCollectionFolderItemFormat: Codable {

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

public struct DiscogsCollectionFolderItemInformation: Codable, HasDiscogsArtistSummaries, Unique {

    public var artists: [DiscogsArtistSummary]?
    public var identifier: Int
    public var coverImage: String?
    public var formats: [DiscogsCollectionFolderItemFormat]?
    public var labels: [DiscogsCollectionFolderItemLabel]?
    public var resourceUrl: String
    public var thumb: String?
    public var title: String
    public var year: Int?

    private enum CodingKeys: String, CodingKey {
        case artists
        case identifier = "id"
        case coverImage = "cover_image"
        case formats
        case labels
        case resourceUrl = "resource_url"
        case thumb
        case title
        case year
    }

}

public struct DiscogsCollectionFolderItemLabel: Codable, Unique {

    public var catalogNumber: String?
    public var entityType: String?
    public var entityTypeName: String?
    public var identifier: Int
    public var name: String
    public var resourceUrl: String

    fileprivate enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case entityType = "entity_type"
        case entityTypeName = "entity_type_name"
        case identifier = "id"
        case name
        case resourceUrl = "resource_url"
    }

}

public struct DiscogsCollectionFolderItems: Codable, Pageable {

    public var pagination: DiscogsPagination?
    public var releases: [DiscogsCollectionFolderItem]?

}

public struct DiscogsCollectionFolderNote: Codable {

    public var fieldId: Int
    public var value: String

    private enum CodingKeys: String, CodingKey {
        case fieldId = "field_id"
        case value
    }

}
