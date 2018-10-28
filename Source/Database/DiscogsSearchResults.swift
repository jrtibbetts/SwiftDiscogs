//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsSearchResult: Codable, Unique {

    public var catno: String?
    public var catalogNumber: String? { return catno }
    public var community: DiscogsCommunity?
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

}

public struct DiscogsSearchResults: Codable {
    
    public var results: [DiscogsSearchResult]?
    
}
