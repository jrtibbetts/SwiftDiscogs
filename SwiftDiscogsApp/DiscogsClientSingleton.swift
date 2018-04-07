//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import Foundation

public extension DiscogsClient {

    /// The `Codable` struct that's parsed out of the Discogs.plist file.
    fileprivate struct Properties: Codable {
        /// The Discogs-issued consumer key hash.
        var consumerKey: String
        /// The Discogs-issued secret key hash for this app.
        var consumerSecret: String
        /// The Discogs API requires that all requests include a `User-Agent`
        /// header value.
        var userAgent: String
    }

    /// A global instance of the `DiscogsClient`. It's initialized with
    /// consumer key, consumer secret, and userAgent properties in a file
    /// named `Discogs.plist`.
    static let singleton: DiscogsClient? = {
        let bundle = Bundle(for: AppDelegate.self)
        let plistPath = bundle.url(forResource: "Discogs", withExtension: "plist")!

        do {
            let propertyData = try Data(contentsOf: plistPath)
            let properties = try PropertyListDecoder().decode(Properties.self, from: propertyData)
            let client = DiscogsClient(consumerKey: properties.consumerKey,
                                       consumerSecret: properties.consumerSecret,
                                       userAgent: properties.userAgent)

            return client
        } catch {
            print("Failed to load the properties from Discogs.plist: \(error.localizedDescription)")
            
            return nil
        }
    }()

}
