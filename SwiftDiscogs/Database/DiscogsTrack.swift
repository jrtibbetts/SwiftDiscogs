//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsTrack: Codable {
    public var duration: String
    public var position: String
    public var type_: String
    public var title: String
    public var extraartists: [DiscogsArtistSummary]?
}
