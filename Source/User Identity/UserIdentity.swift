//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public struct UserIdentity: Codable, Unique {

    public var id: Int
    public var consumerName: String
    public var resourceUrl: String
    public var username: String

}
