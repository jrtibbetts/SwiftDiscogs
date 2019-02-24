//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct BandMember: Codable, Unique {

    public var active: Bool?
    public var id: Int
    public var name: String
    public var resourceUrl: String

}
