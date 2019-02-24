//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public struct Track: Codable {
    
    public var duration: String
    public var position: String
    public var type: String
    public var title: String
    public var extraArtists: [ArtistSummary]?

    private enum CodingKeys: String, CodingKey {
        case duration
        case extraArtists = "extraartists"
        case position
        case title
        case type = "type_"
    }

}
