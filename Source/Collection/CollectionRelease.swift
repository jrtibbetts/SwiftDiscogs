//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public struct CollectionRelease: Codable {
    
    public var basicInformation: [Information]?
    public var folderId: Int
    public var id: Int
    public var instanceId: Int
    public var notes: [Note]?
    public var rating: Int

    public struct Artist: Codable {
        public var anv: String?
        public var id: Int
        public var join: String?
        public var name: String
        public var resourceUrl: String
        public var tracks: String?
        public var role: String?
    }

    public struct Format: Codable {

        public var descriptions: [String]?
        public var name: String?
        public var quantity: String?

        private enum CodingKeys: String, CodingKey {
            case descriptions
            case name
            case quantity = "qty"
        }

    }

    public struct Information: Codable {
        public var id: Int
        public var title: String
        public var year: Int?
        public var resourceUrl: String
        public var thumb: String?
        public var coverImage: String?
        public var formats: [Format]?
        public var labels: [Label]?
        public var artists: [Artist]?
    }

    public struct Label: Codable {

        public var catalogNumber: String?
        public var entityType: String?
        public var id: Int
        public var name: String
        public var resourceUrl: String

        private enum CodingKeys: String, CodingKey {
            case catalogNumber = "catno"
            case entityType
            case id
            case name
            case resourceUrl
        }

    }

    public struct Note: Codable {
        public var fieldId: String
        public var value: String
    }

}
