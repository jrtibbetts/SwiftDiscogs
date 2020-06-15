//  Copyright © 2020 Poikile Creations. All rights reserved.

import Combine
import Foundation
import Medi8
import SwiftUI

public struct DiscogsClient {

    private static var appKey = "iLRYdjOkvzQCWsHAxKMlZCXufHcaIJoRWrMXaxaT"

    private static var baseUrl = URL(string: "https://api.discogs.com")!

    private var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Authorization: Discogs token": DiscogsClient.appKey]
        config.httpCookieAcceptPolicy = .always
        config.timeoutIntervalForRequest = 10.0

        let session = URLSession(configuration: config)

        return session
    }()

    public func search(for searchTerms: String,
                       handleResult: @escaping (Result<[Artist], Error>) -> Void) {
        let url = URL(string: "/database/search?q=\(searchTerms)", relativeTo: DiscogsClient.baseUrl)!
        urlSession.dataTask(with: url) { (data, response, error) in
            if (response as? HTTPURLResponse)?.statusCode == 200 {
//                handleResult(
            }
        }
    }

}
