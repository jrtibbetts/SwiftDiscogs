//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsSearchResults: Codable {

    public var results: [DiscogsSearchResult]?

}

public struct DiscogsSearchResult: Codable, Unique {

    public var catalogNumber: String?
    public var community: DiscogsCommunity?
    public var country: String?
    public var format: [String]?
    public var genre: [String]?
    public var identifier: Int
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
        case identifier = "id"
        case label
        case resourceUrl = "resource_url"
        case style
        case thumb
        case title
        case type
        case uri
        case year
    }

}

public struct DiscogsCommunity: Codable {
    public var have: Int
    public var want: Int
}
