//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsUserProfile: Codable {
    public var avatar_url: String
    public var banner_url: String
    public var buyer_num_ratings: Int
    public var buyer_rating: Int
    public var buyer_rating_stars: Int
    public var collection_fields_url: String
    public var collection_folders_url: String
    public var curr_abbr: String
    public var id: Int
    public var home_page: String
    public var inventory_url: String
    public var location: String
    public var name: String
    public var num_collection: Int
    public var num_for_sale: Int
    public var num_lists: Int
    public var num_pending: Int
    public var num_wantlist: Int
    public var profile: String
    public var rank: Int
    public var rating_avg: Float
    public var registered: String
    public var releases_contributed: Int
    public var releases_rated: Int
    public var resource_url: String
    public var seller_num_ratings: Int
    public var seller_rating: Int
    public var seller_rating_stars: Int
    public var uri: String
    public var username: String
    public var wantlist_url: String
}
