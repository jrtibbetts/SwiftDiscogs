//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsReleaseSummaries: Codable, Pageable {

    public var pagination: DiscogsPagination?
    public var releases: [DiscogsReleaseSummary]

}

public struct DiscogsReleaseSummary: Codable, Unique {

    public var artist: String
    public var catno: String?
    public var catalogNumber: String? { return catno }
    public var format: String?
    public var id: Int
    public var label: String?
    public var mainRelease: Int?
    public var resourceUrl: String
    public var role: String?
    public var status: String?
    public var thumb: String?
    public var title: String
    public var type: String?
    public var year: Int?

    public var formats: [String]? {
        return format?.components(separatedBy: ",").map { (substringChars) -> String in
            let substring = String(substringChars)

            return substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } 
    }

}
