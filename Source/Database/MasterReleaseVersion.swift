//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct MasterReleaseVersion: Codable, Unique {
    
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

public struct MasterReleaseVersions: Codable, Pageable {
    
    public var pagination: Pagination?
    public var versions: [MasterReleaseVersion]
    
}
