//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsUserIdentity: Codable, Unique {

    public var id: Int
    public var consumerName: String
    public var resourceUrl: String
    public var username: String

}
