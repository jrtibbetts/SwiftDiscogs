//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsUserIdentity: Codable, Unique {

    public var id: Int
    public var consumerName: String
    public var resourceUrl: URL
    public var username: String

    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case consumerName = "consumer_name"
        case resourceUrl = "resource_url"
        case username
    }

}
