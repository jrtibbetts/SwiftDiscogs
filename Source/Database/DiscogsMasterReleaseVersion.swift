//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsMasterReleaseVersions: Codable, Pageable {

    public var pagination: DiscogsPagination?
    public var versions: [DiscogsMasterReleaseVersion]

}

public struct DiscogsMasterReleaseVersion: Codable, Unique {

    public var catalogNumber: String?
    public var country: String?
    public var formats: [String]?
    public var identifier: Int
    public var label: String?
    public var majorFormats: [String]?
    public var released: String?
    public var resourceUrl: String
    public var status: String?
    public var thumb: String?
    public var title: String

    private enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case country
        case formats
        case identifier = "id"
        case label
        case majorFormats = "major_formats"
        case released
        case resourceUrl = "resource_url"
        case status
        case thumb
        case title
    }

}
