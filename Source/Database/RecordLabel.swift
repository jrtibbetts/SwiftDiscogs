//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

public struct RecordLabel: Codable, Unique {

    public var contactInfo: String?
    public var dataQuality: String?
    public var id: Int
    public var images: [Image]?
    public var name: String
    public var profile: String?
    public var releasesUrl: URL
    public var resourceUrl: String
    public var sublabels: [Sublabel]?
    public var uri: String
    public var urls: [String]?

}

// swiftlint:enable identifier_name
