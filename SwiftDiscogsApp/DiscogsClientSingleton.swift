//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import Foundation

public extension DiscogsClient {

    /// A global instance of the `DiscogsClient`. It's initialized with
    /// consumer key, consumer secret, and userAgent properties in a file
    /// named `Discogs.plist`.
    static let singleton: DiscogsClient? = {
        let environment = ProcessInfo.processInfo.environment
        let client = DiscogsClient(consumerKey: environment["discogsConsumerKey"]!,
                                   consumerSecret: environment["discogsConsumerSecret"]!,
                                   userAgent: environment["discogsUserAgent"]!)

        return client
    }()

}
