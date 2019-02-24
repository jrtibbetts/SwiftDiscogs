//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public struct Artist: Codable, Unique {
    
    public var dataQuality: String?
    public var id: Int
    public var images: [Image]?
    public var members: [BandMember]?
    public var name: String?
    public var namevariations: [String]?
    public var profile: String?
    public var releasesUrl: URL
    public var resourceUrl: String
    public var urls: [String]?
    
}
