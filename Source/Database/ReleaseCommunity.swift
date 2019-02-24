//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct ReleaseCommunity: Codable {

    public var contributors: [ReleaseContributor]
    public var dataQuality: String?
    public var have: Int
    public var status: String?
    public var submitter: ReleaseContributor?
    public var want: Int

}
