//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

public protocol Pageable {

    var pagination: Pagination? { get }

}

public struct Pagination: Codable {

    public var page: Int
    public var pages: Int
    public var items: Int
    public var perPage: Int
    public var urls: [String : URL]

}
