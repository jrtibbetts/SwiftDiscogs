//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsImage: Codable {

    public var height: Int
    public var resourceUrl: String
    public var type: String
    public var uri: String
    public var uri150: String
    public var width: Int

    fileprivate enum CodingKeys: String, CodingKey {
        case height
        case resourceUrl = "resource_url"
        case type
        case uri
        case uri150
        case width
    }
    
}
