//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsUserProfile: Codable {
    public var avatarUrl: String
    public var bannerUrl: String
    public var buyerRating: Int
    public var buyerRatingCount: Int
    public var buyerRatingStars: Int
    public var collectionCount: Int
    public var collectionFieldsUrl: String
    public var collectionFoldersUrl: String
    public var contributedReleasesCount: Int
    public var currentAbbreviation: String
    public var forSaleCount: Int
    public var id: Int
    public var homePage: String?
    public var inventoryUrl: URL?
    public var location: String
    public var name: String
    public var listCount: Int
    public var pendingCount: Int
    public var profile: String
    public var rank: Int
    public var ratingAverage: Float
    public var registered: String
    public var ratedReleasesCount: Int
    public var resourceUrl: String
    public var sellerRatingCount: Int
    public var sellerRating: Int
    public var sellerRatingStars: Int
    public var uri: String
    public var username: String
    public var wantlistCount: Int
    public var wantlistUrl: URL

    fileprivate enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case bannerUrl = "banner_url"
        case buyerRating = "buyer_rating"
        case buyerRatingCount = "buyer_num_ratings"
        case buyerRatingStars = "buyer_rating_stars"
        case collectionCount = "num_collection"
        case collectionFieldsUrl = "collection_fields_url"
        case collectionFoldersUrl = "collection_folders_url"
        case contributedReleasesCount = "releases_contributed"
        case currentAbbreviation = "curr_abbr"
        case forSaleCount = "num_for_sale"
        case id
        case homePage = "home_page"
        case inventoryUrl = "inventoryUrl"
        case location
        case name
        case listCount = "num_lists"
        case pendingCount = "num_pending"
        case profile
        case rank
        case ratingAverage = "rating_avg"
        case registered
        case ratedReleasesCount = "releases_rated"
        case resourceUrl = "resource_url"
        case sellerRatingCount = "seller_num_ratings"
        case sellerRating = "seller_rating"
        case sellerRatingStars = "seller_rating_stars"
        case uri
        case username
        case wantlistCount = "num_wantlist"
        case wantlistUrl = "wantlist_url"
    }
}
