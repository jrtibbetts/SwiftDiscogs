//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsMasterReleaseVersion: Codable, Unique {
    
    public var catno: String?
    public var country: String?
    public var formats: [String]?
    public var id: Int
    public var label: String?
    public var majorFormats: [String]?
    public var released: String?
    public var resourceUrl: String
    public var status: String?
    public var thumb: String?
    public var title: String
    
}

public struct DiscogsMasterReleaseVersions: Codable, Pageable {
    
    public var pagination: DiscogsPagination?
    public var versions: [DiscogsMasterReleaseVersion]
    
}
