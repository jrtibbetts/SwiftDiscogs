//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsUserIdentity: Codable, Unique {

    public var identifier: Int
    public var consumerName: String
    public var resourceUrl: String
    public var username: String

    fileprivate enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case consumerName = "consumer_name"
        case resourceUrl = "resource_url"
        case username
    }

}
