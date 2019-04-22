//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public struct CollectionFolderItem: Codable {
    
    public var folderId: Int
    public var id: Int
    public var basicInformation: DiscogsCollectionFolderItemInformation?
    public var instanceId: Int
    public var notes: [DiscogsCollectionFolderNote]?
    public var rating: Int
    
}

public struct DiscogsCollectionFolderItemFormat: Codable {
    
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

public struct DiscogsCollectionFolderItemInformation: Codable, HasArtistSummaries, Unique {
    
    public var artists: [ArtistSummary]?
    public var coverImage: String?
    public var formats: [DiscogsCollectionFolderItemFormat]?
    public var id: Int
    public var labels: [DiscogsCollectionFolderItemLabel]?
    public var resourceUrl: String
    public var thumb: String?
    public var title: String
    public var year: Int?
    
}

public struct DiscogsCollectionFolderItemLabel: Codable, Unique {
    
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

public struct DiscogsCollectionFolderItems: Codable, Pageable {
    
    public var pagination: Pagination?
    public var releases: [CollectionFolderItem]?
    
}

public struct DiscogsCollectionFolderNote: Codable {
    
    public var fieldId: Int
    public var value: String
    
}
