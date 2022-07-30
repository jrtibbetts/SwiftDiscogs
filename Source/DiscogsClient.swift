//  Copyright © 2017 Poikile Creations. All rights reserved.

import JSONClient
import OAuthSwift
import UIKit

/// Swift implementation of the Discogs (https://www.discogs.com) API. Most
/// calls return a `Promise`, which the API call will populate with either a
/// populated object of the expected type, or an error.
open class DiscogsClient: OAuth1JSONClient, Discogs {

    public private(set) var userAgent: String

    // MARK: - Private properties

    private var headers: OAuthSwift.Headers = [:]

    // MARK: - Initializers

    /// Initialize the Discogs client. This doesn't make any calls to the
    /// Discogs API; that happens in `authorize()`.
    public init(consumerKey: String,
                consumerSecret: String,
                userAgent: String) {
        self.userAgent = userAgent
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        super.init(consumerKey: consumerKey,
                   consumerSecret: consumerSecret,
                   requestTokenUrl: "https://api.discogs.com/oauth/request_token",
                   authorizeUrl: "https://www.discogs.com/oauth/authorize",
                   accessTokenUrl: "https://api.discogs.com/oauth/access_token",
                   baseUrl: URL(string: "https://api.discogs.com")!,
                   jsonDecoder: jsonDecoder)
        /// Discogs requires all API calls to include a custom `User-Agent`
        /// header.
        headers["User-Agent"] = self.userAgent
    }

    // MARK: - JSONClient

    open override func get<T>(path: String,
                              headers: JSONClient.Headers = Headers(),
                              parameters: JSONClient.Parameters = Parameters())
        async -> T where T: Decodable, T: Encodable {
        print("GET for \(path); headers: \(headers); params: \(parameters)")
        debugPrint(path, headers, parameters)
        return super.get(path: path, headers: headers, parameters: parameters)
    }

    // MARK: - AuthorizedJSONClient

    open override func authorizedGet<T>(path: String,
                                        headers: AuthorizedJSONClient.Headers = Headers(),
                                        parameters: AuthorizedJSONClient.Parameters = Parameters())
        async -> T where T: Decodable, T: Encodable {
        print("Authorized GET for \(path); headers: \(headers); params: \(parameters)")
        debugPrint(path, headers, parameters)
        return super.authorizedGet(path: path, headers: headers, parameters: parameters)
    }

    // MARK: - Authorization & User Identity

    public func userIdentity() async -> UserIdentity {
        return await authorizedGet(path: "/oauth/identity", headers: headers)
    }

    public func userProfile(userName: String) async -> UserProfile {
        return await authorizedGet(path: "/users/\(userName)", headers: headers)
    }

    // MARK: - Database

    public func artist(identifier: Int) async -> Artist {
        return await get(path: "/artists/\(identifier)", headers: headers)
    }

    public func label(identifier: Int) async -> RecordLabel {
        return await get(path: "/labels/\(identifier)", headers: headers)
    }

    public func masterRelease(identifier: Int) async -> MasterRelease {
        return await get(path: "/masters/\(identifier)", headers: headers)
    }

    public func release(identifier: Int) async -> Release {
        return await get(path: "/releases/\(identifier)", headers: headers)
    }

    public func releases(forArtist artistId: Int) async -> ReleaseSummaries {
        return await get(path: "/artists/\(artistId)/releases", headers: headers)
    }

    public func releases(forLabel labelId: Int) async -> ReleaseSummaries {
        return await get(path: "/labels/\(labelId)/releases", headers: headers)
    }

    public func releasesForMasterRelease(_ identifier: Int,
                                         pageNumber: Int = 1,
                                         resultsPerPage: Int = 50) async -> MasterReleaseVersions {
        // turn the pageNumber and resultsPerPage into query parameters
        return await get(path: "/masters/\(identifier)/versions",
            headers: headers,
            parameters: ["per_page": "\(resultsPerPage)", "page": "\(pageNumber)"])
    }

    // MARK: - Collections

    public func customCollectionFields(forUserName userName: String) async -> CollectionCustomFields {
        return await authorizedGet(path: "/users/\(userName)/collection/fields", headers: headers)
    }

    public func collectionValue(forUserName userName: String) async -> CollectionValue {
        return await authorizedGet(path: "/users/\(userName)/collection/value", headers: headers)
    }

    public func collectionFolders(forUserName userName: String) async -> CollectionFolders {
        return await authorizedGet(path: "/users/\(userName)/collection/folders", headers: headers)
    }

    public func collectionFolderInfo(forFolderID folderID: Int,
                                     userName: String) async -> CollectionFolder {
        return await authorizedGet(path: "/users/\(userName)/collection/folders/\(folderID)", headers: headers)
    }

    public func createFolder(named folderName: String,
                             forUserName userName: String) async -> CollectionFolder {
        return authorizedPost(path: "/users/\(userName)/collection/folders/\(folderName)", headers: headers)
    }

    public func edit(_ folder: CollectionFolder,
                     forUserName userName: String) async -> CollectionFolder {
        return Promise<CollectionFolder> { _ in
        }
    }

    public func collectionItems(inFolderID folderID: Int,
                                userName: String,
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) async -> CollectionFolderItems {
        return await authorizedGet(path: "/users/\(userName)/collection/folders/\(folderID)/releases",
            headers: headers,
            parameters: ["per_page": "\(resultsPerPage)", "page": "\(pageNumber)"])
    }

    public func addItem(_ itemID: Int,
                        toFolderID folderID: Int,
                        userName: String) async -> CollectionItemInfo {
        return authorizedPost(
            path: "/users/\(userName)/collection/folders/\(folderID)/releases/{itemId}",
            headers: headers)
    }

    // MARK: - Search

    public func search(for queryString: String,
                       type: String) async -> SearchResults {
        let params = ["q": queryString]

        return await authorizedGet(path: "/database/search", headers: headers, parameters: params)
    }

}
