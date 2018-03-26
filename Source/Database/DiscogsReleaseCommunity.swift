//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseCommunity: Codable {

    public var contributors: [DiscogsReleaseContributor]
    public var dataQuality: String?
    public var have: Int
    public var status: String?
    public var submitter: DiscogsReleaseContributor?
    public var want: Int

    fileprivate enum CodingKeys: String, CodingKey {
        case contributors
        case dataQuality = "data_quality"
        case have
        case status
        case submitter
        case want
    }

}
