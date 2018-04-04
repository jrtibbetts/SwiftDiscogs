//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public protocol Pageable {

    var pagination: DiscogsPagination? { get }

}

public struct DiscogsPagination: Codable {

    public var page: Int
    public var pages: Int
    public var items: Int
    public var perPage: Int
    public var urls: [String : URL]

}
