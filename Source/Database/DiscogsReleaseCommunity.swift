//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsReleaseCommunity: Codable {

    public var contributors: [DiscogsReleaseContributor]
    public var dataQuality: String?
    public var have: Int
    public var status: String?
    public var submitter: DiscogsReleaseContributor?
    public var want: Int

}
