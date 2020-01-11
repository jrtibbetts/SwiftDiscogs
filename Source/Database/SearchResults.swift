//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

public struct SearchResult: Codable, Unique {

    public var catalogNumber: String?
    public var community: Community?
    public var country: String?
    public var format: [String]?
    public var genre: [String]?
    public var id: Int
    public var label: [String]?
    public var resourceUrl: String
    public var style: [String]?
    public var thumb: String?
    public var title: String
    public var type: String
    public var uri: String
    public var year: String?

    private enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case community
        case country
        case format
        case genre
        case id
        case label
        case resourceUrl
        case style
        case thumb
        case title
        case type
        case uri
        case year
    }

}

public struct SearchResults: Codable {

    public var results: [SearchResult]?

}

// swiftlint:enable identifier_name
