//  Copyright © 2020 Poikile Creations. All rights reserved.

import Combine
import Foundation
import Medi8
import SwiftUI

public struct DiscogsClient {

    private static var appKey = "iLRYdjOkvzQCWsHAxKMlZCXufHcaIJoRWrMXaxaT"

    private static var baseUrl = URL(string: "https://api.discogs.com")!

    public var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Authorization: Discogs token": DiscogsClient.appKey]
        config.httpCookieAcceptPolicy = .always
        config.timeoutIntervalForRequest = 10.0

        let session = URLSession(configuration: config)

        return session
    }()

    public func search(for searchTerms: String) async throws -> [Artist] {
        let url = URL(string: "/database/search?q=\(searchTerms)", relativeTo: DiscogsClient.baseUrl)!
        let data = try await urlSession.data(from: url)

        return []
    }

}
