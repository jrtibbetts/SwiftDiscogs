//  Copyright © 2017 Poikile Creations. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

public struct UserProfile: Codable {

    public var avatarUrl: String
    public var bannerUrl: String
    public var buyerNumRatings: Int
    public var buyerRating: Int
    public var buyerRatingStars: Int
    public var collectionFieldsUrl: String
    public var collectionFoldersUrl: String
    public var currAbbr: String
    public var id: Int
    public var homePage: String?
    public var inventoryUrl: URL?
    public var location: String
    public var name: String
    public var numCollection: Int
    public var numForSale: Int
    public var numLists: Int
    public var numPending: Int
    public var numWantlist: Int
    public var profile: String
    public var rank: Int
    public var ratingAvg: Float
    public var registered: String
    public var releasesContributed: Int
    public var releasesRated: Int
    public var resourceUrl: String
    public var sellerNumRatings: Int
    public var sellerRating: Int
    public var sellerRatingStars: Int
    public var uri: String
    public var username: String
    public var wantlistUrl: URL

}

// swiftlint:enable identifier_name
