//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsArtistReleases: Codable {
    
    public var releases: [DiscogsArtistRelease]?
    
}

public struct DiscogsArtistRelease: Codable, Unique {
    
    public var artist: String
    public var format: String?
    public var id: Int
    public var label: String?
    public var mainRelease: Int
    public var resourceUrl: String
    public var role: String?
    public var status: String?
    public var thumb: String?
    public var title: String
    public var type: String
    public var year: Int
    
    public var formats: [String]? {
        return format?.split(separator: ",").map { (substring) -> String in
            return String(substring)
        }
    }
    
}
