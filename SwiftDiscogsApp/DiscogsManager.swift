//
//  DiscogsManager.swift
//  SwiftDiscogsApp
//
//  Created by Jason R Tibbetts on 4/16/19.
//  Copyright © 2019 Poikile Creations. All rights reserved.
//

import SwiftDiscogs

public struct DiscogsManager {

    public static var discogs: Discogs = discogsClient

    /// A global instance of the `DiscogsClient`. It's initialized with
    /// consumer key, consumer secret, and userAgent properties in a file
    /// named `Discogs.plist`.
    private static let discogsClient: DiscogsClient = {
        let environment = ProcessInfo.processInfo.environment
        let client = DiscogsClient(consumerKey: environment["discogsConsumerKey"]!,
                                   consumerSecret: environment["discogsConsumerSecret"]!,
                                   userAgent: environment["discogsUserAgent"]!)

        return client
    }()

}
