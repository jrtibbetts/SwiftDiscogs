//  Copyright © 2017 Poikile Creations. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit
import UIKit

/// A `Discogs` implementation that generates canned values from the sample
/// JSON code documented at api.discogs.com.
public class MockDiscogs: MockClient, Discogs {
    
    public init(errorMode: Bool = false) {
        let bundle = Bundle(for: MockDiscogs.self)
        
        if errorMode {
            super.init(errorDomain: "net.immediate.MockDiscogs", bundle: bundle)
        } else {
            super.init(bundle: bundle)
        }
    }

    // MARK: - User Identity

    public func authorize(presentingViewController: UIViewController,
                          callbackUrlString: String) -> Promise<OAuthSwiftCredential> {
        return Promise<OAuthSwiftCredential> { (seal) in
            seal.fulfill(OAuthSwiftCredential.init(consumerKey: "key", consumerSecret: "secret"))
        }
    }

    public var isSignedIn: Bool {
        return !errorMode
    }

    public func signOut() {
        // There's nothing to do.
    }
    
    public func userIdentity() -> Promise<UserIdentity> {
        return apply(toJsonObjectIn: "get-user-identity-200",
                     error: DiscogsError.unauthenticatedUser)
    }

    public func userProfile(userName: String) -> Promise<UserProfile> {
        return apply(toJsonObjectIn: "get-user-profile-200",
                     error: DiscogsError.unauthenticatedUser)
    }
    
    // MARK: - Database
    
    public func artist(identifier: Int) -> Promise<Artist> {
        return apply(toJsonObjectIn: "get-artist-200",
                     error: DiscogsError.artistNotFoundById(identifier))
    }
    
    public func releases(forArtist artistId: Int) -> Promise<ReleaseSummaries> {
        return apply(toJsonObjectIn: "get-release-summaries-200",
                     error: DiscogsError.artistNotFoundById(artistId))
    }
    
    public func label(identifier: Int) -> Promise<RecordLabel> {
        return apply(toJsonObjectIn: "get-label-200",
                     error: DiscogsError.labelNotFoundById(identifier))
    }
    
    public func releases(forLabel labelId: Int) -> Promise<ReleaseSummaries> {
        return apply(toJsonObjectIn: "get-label-releases-200",
                     error: DiscogsError.labelNotFoundById(labelId))
    }
    
    public func masterRelease(identifier: Int) -> Promise<MasterRelease> {
        return apply(toJsonObjectIn: "get-master-200",
                     error: DiscogsError.masterReleaseNotFoundById(identifier))
    }
    
    public func releasesForMasterRelease(_ identifier: Int,
                                         pageNumber: Int = 0,
                                         resultsPerPage: Int = 50) -> Promise<MasterReleaseVersions> {
        return apply(toJsonObjectIn: "get-master-release-versions-200",
                     error: DiscogsError.masterReleaseNotFoundById(identifier))
    }
    
    public func release(identifier: Int) -> Promise<Release> {
        return apply(toJsonObjectIn: "get-release-200",
                     error: DiscogsError.masterReleaseNotFoundById(identifier))
    }
    
    // MARK: - Collections
    
    public func customCollectionFields(forUserName userName: String) -> Promise<CollectionCustomFields> {
        return apply(toJsonObjectIn: "get-custom-fields-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionValue(forUserName userName: String) -> Promise<CollectionValue> {
        return apply(toJsonObjectIn: "get-collection-value-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionFolders(forUserName userName: String) -> Promise<CollectionFolders> {
        return apply(toJsonObjectIn: "get-folders-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionFolderInfo(forFolderID folderID: Int,
                                     userName: String) -> Promise<CollectionFolder> {
        return apply(toJsonObjectIn: "get-folder-metadata-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func createFolder(named folderName: String,
                             forUserName userName: String) -> Promise<CollectionFolder> {
        return apply(toJsonObjectIn: "post-create-folder-201",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func edit(_ folder: CollectionFolder,
                     forUserName userName: String) -> Promise<CollectionFolder> {
        return apply(toJsonObjectIn: "post-edit-folder-metadata-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionItems(inFolderID folderID: Int,
                                userName: String,
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) -> Promise<CollectionFolderItems> {
        return apply(toJsonObjectIn: "collection-folder-items-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func addItem(_ itemID: Int,
                        toFolderID folderID: Int,
                        userName: String) -> Promise<CollectionItemInfo> {
        return apply(toJsonObjectIn: "add-item-to-collection-folder-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    // MARK: - Search
    
    public func search(for queryString: String, type: String = "title") -> Promise<SearchResults> {
        return apply(toJsonObjectIn: "search-200",
                     error: DiscogsError.unknown(nil))
    }
    
}
