//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

public struct MasterReleaseVersion: Codable, Unique {

    public var catalogNumber: String?
    public var country: String?
    public var formats: [String]?
    public var id: Int
    public var label: String?
    public var majorFormats: [String]?
    public var released: String?
    public var resourceUrl: String
    public var status: String?
    public var thumbnail: String?
    public var title: String

    public var format: String? {
        return formats?.first
    }

    public var mainCatalogNumber: String? {
        if let firstNumber = catalogNumber?.split(separator: ",").first {
            return String(firstNumber)
        } else {
            return nil
        }
    }

    public var majorFormat: String? {
        return majorFormats?.first
    }

    private enum CodingKeys: String, CodingKey {
        case catalogNumber = "catno"
        case country
        case formats
        case id
        case label
        case majorFormats
        case released
        case resourceUrl
        case status
        case thumbnail = "thumb"
        case title
    }

}

public struct MasterReleaseVersions: Codable, Pageable {

    public var pagination: Pagination?
    public var versions: [MasterReleaseVersion]

}

// swiftlint:enable identifier_name
