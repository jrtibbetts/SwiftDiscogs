//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionRelease: Codable {

    public var basicInformation: [BasicInformation]?
    public var folderId: Int
    public var id: Int
    public var instanceId: Int
    public var notes: [Note]?
    public var rating: Int

    fileprivate enum CodingKeys: String, CodingKey {
        case basicInformation = "basic_information"
        case folderId = "folder_id"
        case id
        case instanceId = "instance_id"
        case notes
        case rating
    }

    // MARK: -

    public struct Artist: Codable {
        public var anv: String?
        public var id: Int
        public var join: String?
        public var name: String
        public var resourceUrl: String
        public var tracks: String?
        public var role: String?

        fileprivate enum CodingKeys: String, CodingKey {
            case anv
            case id
            case join
            case name
            case resourceUrl = "resource_url"
            case role
            case tracks
        }
    }

    // MARK: -

    public struct BasicInformation: Codable {
        public var id: Int
        public var title: String
        public var year: Int?
        public var resourceUrl: String
        public var thumb: String?
        public var coverImage: String?
        public var formats: [Format]?
        public var labels: [Label]?
        public var artists: [Artist]?

        fileprivate enum CodingKeys: String, CodingKey {
            case artists
            case coverImage = "cover_image"
            case formats
            case id
            case labels
            case resourceUrl = "resource_url"
            case thumb
            case title
            case year
        }
    }

    // MARK: -

    public struct Format: Codable {
        public var descriptions: [String]?
        public var name: String?
        public var quantity: String?

        fileprivate enum CodingKeys: String, CodingKey {
            case descriptions
            case name
            case quantity = "qty"
        }
    }

    // MARK: -

    public struct Label: Codable {
        public var catalogNumber: String?
        public var entityType: String?
        public var id: Int
        public var name: String
        public var resourceUrl: String

        fileprivate enum CodingKeys: String, CodingKey {
            case catalogNumber = "catno"
            case entityType = "entity_type"
            case id
            case name
            case resourceUrl = "resource_url"
        }
    }

    // MARK: -

    public struct Note: Codable {
        public var fieldId: String
        public var value: String

        fileprivate enum CodingKeys: String, CodingKey {
            case fieldId = "field_id"
            case value
        }
    }

}
