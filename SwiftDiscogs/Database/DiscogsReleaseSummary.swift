//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsReleaseSummaries: Codable, Pageable {

    public var pagination: DiscogsPagination?
    public var releases: [DiscogsReleaseSummary]

}

public struct DiscogsReleaseSummary: Codable, Unique {

    private enum CodingKeys: String, CodingKey {
        case artist
        case catalogNumber = "catno"
        case format
        case id
        case label
        case mainReleaseId = "main_release"
        case resourceUrl = "resource_url"
        case role
        case status
        case thumb
        case title
        case type
        case year
    }

    public var artist: String
    public var catalogNumber: String?
    public var format: String?
    public var id: Int
    public var label: String?
    public var mainReleaseId: Int?
    public var resourceUrl: String
    public var role: String?
    public var status: String?
    public var thumb: String?
    public var title: String
    public var type: String?
    public var year: Int

    public var formats: [String]? {
        return format?.components(separatedBy: ",").map { (substringChars) -> String in
            let substring = String(substringChars)

            return substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } 
    }
}

