//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionItemInfo: Codable {
    
    public var instanceId: Int
    public var resourceUrl: String

    fileprivate enum CodingKeys: String, CodingKey {
        case instanceId = "instance_id"
        case resourceUrl = "resource_url"
    }

}
