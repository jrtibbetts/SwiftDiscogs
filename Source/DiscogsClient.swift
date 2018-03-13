//  Copyright © 2017 nrith. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit

/// Swift implementation of the Discogs (https://www.discogs.com) API. Most
/// calls return a `Promise`, which the API call will populate with either
/// a populated `struct` of the expected type, or an error.
open class DiscogsClient: OAuth1JSONClient, Discogs {

    // MARK: - Private properties

    fileprivate var headers: OAuthSwift.Headers = [:]

    fileprivate var userAgent: String

    // MARK: - Initializers
    
    /// Initialize the Discogs API. This doesn't make any calls to the Discogs
    /// API; that happens in `authorize()`.
    ///
    public init(consumerKey: String,
                consumerSecret: String,
                userAgent: String,
                callbackUrl: URL) {
        self.userAgent = userAgent
        /// Discogs requires all API calls to include a custom `User-Agent`
        /// header.
        super.init(consumerKey: consumerKey,
                   consumerSecret: consumerSecret,
                   requestTokenUrl: "https://api.discogs.com/oauth/access_token",
                   authorizeUrl: "https://www.discogs.com/oauth/authorize",
                   accessTokenUrl: "https://api.discogs.com/oauth/request_token",
                   baseUrl: URL(string: "https://api.discogs.com")!)
        headers["User-Agent"] = self.userAgent
    }

    // MARK: - Authorization & User Identity

    public func userIdentity() -> Promise<DiscogsUserIdentity> {
        return get(path: "/oauth/identity", headers: headers)
    }
    
    public func userProfile(userName: String) -> Promise<DiscogsUserProfile> {
        return get(path: "/users/\(userName)", headers: headers)
    }

    // MARK: - Database
    
    public func artist(id: Int) -> Promise<DiscogsArtist> {
        return get(path: "/artists/\(id)", headers: headers)
    }
    
    public func releases(forArtist artistId: Int) -> Promise<DiscogsReleaseSummaries> {
        return get(path: "/artists/\(artistId)/releases", headers: headers)
    }
    
    public func label(id: Int) -> Promise<DiscogsLabel> {
        return get(path: "/labels/\(id)", headers: headers)
    }
    
    public func releases(forLabel labelId: Int) -> Promise<DiscogsReleaseSummaries> {
        return get(path: "/labels/\(labelId)/releases", headers: headers)
    }
    
    public func masterRelease(id: Int) -> Promise<DiscogsMasterRelease> {
        return get(path: "/masters/\(id)", headers: headers)
    }
    
    public func releasesForMasterRelease(id: Int,
                                         pageNumber: Int = 1,
                                         resultsPerPage: Int = 50) -> Promise<DiscogsMasterReleaseVersions> {
        // turn the pageNumber and resultsPerPage into query parameters
        return get(path: "/masters/\(id)/versions", headers: headers)
    }
    
    public func release(id: Int) -> Promise<DiscogsRelease> {
        return get(path: "/releases/\(id)", headers: headers)
    }
    
    // MARK: - Collections
    
    public func customCollectionFields(for userName: String) -> Promise<DiscogsCollectionCustomFields> {
        return get(path: "/users/\(userName)/collection/fields", headers: headers)
    }
    
    public func collectionValue(for userName: String) -> Promise<DiscogsCollectionValue> {
        return get(path: "/users/\(userName)/collection/value", headers: headers)
    }
    
    public func collectionFolders(for userName: String) -> Promise<DiscogsCollectionFolders> {
        return get(path: "/users/\(userName)/collection/folders", headers: headers)
    }
    
    public func collectionFolderInfo(for folderId: Int,
                                     userName: String) -> Promise<DiscogsCollectionFolder> {
        return get(path: "/users/\(userName)/collection/folders/\(folderId)", headers: headers)
    }
    
    public func createFolder(named folderName: String,
                             userName: String) -> Promise<DiscogsCollectionFolder> {
        let path = "/users/\(userName)/collection/folders/\(folderName)"
        let endpoint = URL(string: path, relativeTo: baseUrl)!
        
        return authorizedPost(url: endpoint, headers: headers)
    }
    
    public func edit(_ folder: DiscogsCollectionFolder,
                     userName: String) -> Promise<DiscogsCollectionFolder> {
        return Promise<DiscogsCollectionFolder>() { (fulfill, reject) in
        }
    }
    
    public func collectionItems(forFolderId folderId: Int,
                                userName: String,
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) -> Promise<DiscogsCollectionFolderItems> {
        // turn the pageNumber and resultsPerPage into query parameters
        return get(path: "/users/\(userName)/collection/folders/\(folderId)/releases",
            headers: headers)
    }
    
    public func addItem(_ itemId: Int,
                        toFolderId folderId: Int,
                        userName: String) -> Promise<DiscogsCollectionItemInfo> {
        let path = "/users/\(userName)/collection/folders/\(folderId)/releases/{itemId}"
        let endpoint = URL(string: path, relativeTo: baseUrl)!
        
        return authorizedPost(url: endpoint, headers: headers)
    }
    
    public func search(for queryString: String,
                       type: String) -> Promise<DiscogsSearchResults> {
        let params = [URLQueryItem(name: "q", value: queryString)]
        
        return get(path: "/database/search", headers: headers, params: params)
    }

}
