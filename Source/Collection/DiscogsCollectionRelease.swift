//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsCollectionRelease: Codable {
    
    public var basicInformation: [DiscogsCollectionReleaseInformation]?
    public var folderId: Int
    public var id: Int
    public var instanceId: Int
    public var notes: [DiscogsCollectionReleaseNote]?
    public var rating: Int
    
}

public struct DiscogsCollectionReleaseArtist: Codable {
    public var anv: String?
    public var id: Int
    public var join: String?
    public var name: String
    public var resourceUrl: String
    public var tracks: String?
    public var role: String?
    
}

public struct DiscogsCollectionReleaseInformation: Codable {
    public var id: Int
    public var title: String
    public var year: Int?
    public var resourceUrl: String
    public var thumb: String?
    public var coverImage: String?
    public var formats: [DiscogsCollectionReleaseFormat]?
    public var labels: [DiscogsCollectionReleaseLabel]?
    public var artists: [DiscogsCollectionReleaseArtist]?
    
}

public struct DiscogsCollectionReleaseFormat: Codable {
    public var descriptions: [String]?
    public var name: String?
    public var quantity: String? { return qty }
    public var qty: String?
    
}

public struct DiscogsCollectionReleaseLabel: Codable {
    public var catno: String?
    public var catalogNumber: String? { return catno }
    public var entityType: String?
    public var id: Int
    public var name: String
    public var resourceUrl: String
    
}

public struct DiscogsCollectionReleaseNote: Codable {
    public var fieldId: String
    public var value: String
    
}
