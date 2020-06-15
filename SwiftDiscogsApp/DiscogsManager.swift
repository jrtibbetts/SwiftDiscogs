//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs

/// Holds the app-wide `Discogs` instance (called `discogs`) that should be
/// used.
public struct DiscogsManager {

    /// The app-wide `Discogs` instance to use. By default, this is a
    /// `DiscogsClient`, but you can set it to something else (like the mock
    /// client) for testing or other purposes.
    public static var discogs: Discogs = discogsClient

    /// A global-ish instance of the `DiscogsClient`. It's initialized with
    /// consumer key, consumer secret, and userAgent properties in a file
    /// named `Discogs.plist`.
    private static let discogsClient: DiscogsClient = {
        let environment = ProcessInfo.processInfo.environment
        let client = DiscogsClient(consumerKey: environment["discogsConsumerKey"]!,
                                   consumerSecret: environment["discogsConsumerSecret"]!,
                                   userAgent: environment["discogsUserAgent"]!)

        return client
    }()

    /// You shouldn't instantiate a `DiscogsManager`. It exists just to hold a
    /// reference to the app-wide `Discogs` instance.
    private init() {

    }

}
