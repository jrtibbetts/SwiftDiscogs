//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionRelease: Codable {

    public struct Artist: Codable {
        public var anv: String?
        public var id: Int
        public var join: String?
        public var name: String
        public var resource_url: String
        public var tracks: String?
        public var role: String?
    }

    public struct BasicInformation: Codable {
        public var id: Int
        public var title: String
        public var year: Int?
        public var resource_url: String
        public var thumb: String?
        public var cover_image: String?
        public var formats: [Format]?
        public var labels: [Label]?
        public var artists: [Artist]?
    }

    public struct Format: Codable {
        public var qty: String?
        public var descriptions: [String]?
        public var name: String?
    }

    public struct Label: Codable {
        public var catno: String?
        public var entity_type: String?
        public var id: Int
        public var name: String
        public var resource_url: String
    }

    public struct Note: Codable {
        public var field_id: String
        public var value: String
    }

    public var basicInformation: [BasicInformation]?
    public var folder_id: Int
    public var id: Int
    public var instance_id: Int
    public var notes: [Note]?
    public var rating: Int
}
