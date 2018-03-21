//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import Foundation

public extension DiscogsClient {

    fileprivate struct Properties: Codable {
        var consumerKey: String
        var consumerSecret: String
        var userAgent: String
    }

    static let singleton: DiscogsClient = {
        let bundle = Bundle(for: AppDelegate.self)
        let plistPath = bundle.url(forResource: "Discogs", withExtension: "plist")!
        let propertyData = try! Data(contentsOf: plistPath)
        let properties = try! PropertyListDecoder().decode(Properties.self, from: propertyData)
        let client = DiscogsClient(consumerKey: properties.consumerKey,
                                   consumerSecret: properties.consumerSecret,
                                   userAgent: properties.userAgent)
        
        return client
    }()

}
