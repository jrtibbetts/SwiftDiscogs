//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import OAuthSwift
import UIKit

/// A `Discogs` implementation that generates canned values from the sample
/// JSON code documented at api.discogs.com.
public class MockDiscogs: MockClient, Discogs {

    public init(errorMode: Bool = false) {
        let bundle = Bundle(for: MockDiscogs.self)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        if errorMode {
            super.init(errorDomain: "net.immediate.MockDiscogs",
                       bundle: bundle,
                       jsonDecoder: jsonDecoder)
        } else {
            super.init(bundle: bundle,
                       jsonDecoder: jsonDecoder)
        }
    }

    // MARK: - User Identity

    public func authorize(presentingViewController: UIViewController,
                          callbackUrlString: String) async throws -> OAuthSwiftCredential {
        return OAuthSwiftCredential(consumerKey: "key", consumerSecret: "secret")
    }

    public var isSignedIn: Bool {
        return !errorMode
    }

    public func signOut() {
        // There's nothing to do.
    }

    public func userIdentity() async throws -> UserIdentity {
        return try await apply(toJsonObjectIn: "get-user-identity-200",
                               error: DiscogsError.unauthenticatedUser)
    }

    public func userProfile(userName: String) async throws -> UserProfile {
        return try await apply(toJsonObjectIn: "get-user-profile-200",
                               error: DiscogsError.unauthenticatedUser)
    }

    // MARK: - Database

    public func artist(identifier: Int) async throws -> Artist {
        return try await apply(toJsonObjectIn: "get-artist-200",
                               error: DiscogsError.artistNotFoundById(identifier))
    }

    public func releases(forArtist artistId: Int) async throws -> ReleaseSummaries {
        return try await apply(toJsonObjectIn: "get-release-summaries-200",
                               error: DiscogsError.artistNotFoundById(artistId))
    }

    public func label(identifier: Int) async throws -> RecordLabel {
        return try await apply(toJsonObjectIn: "get-label-200",
                               error: DiscogsError.labelNotFoundById(identifier))
    }

    public func releases(forLabel labelId: Int) async throws -> ReleaseSummaries {
        return try await apply(toJsonObjectIn: "get-label-releases-200",
                               error: DiscogsError.labelNotFoundById(labelId))
    }

    public func masterRelease(identifier: Int) async throws -> MasterRelease {
        return try await apply(toJsonObjectIn: "get-master-200",
                               error: DiscogsError.masterReleaseNotFoundById(identifier))
    }

    public func releasesForMasterRelease(_ identifier: Int,
                                         pageNumber: Int = 0,
                                         resultsPerPage: Int = 50) async throws -> MasterReleaseVersions {
        return try await apply(toJsonObjectIn: "get-master-release-versions-200",
                               error: DiscogsError.masterReleaseNotFoundById(identifier))
    }

    public func release(identifier: Int) async throws -> Release {
        return try await apply(toJsonObjectIn: "get-release-200",
                               error: DiscogsError.masterReleaseNotFoundById(identifier))
    }

    // MARK: - Collections

    public func customCollectionFields(forUserName userName: String) async throws -> CollectionCustomFields {
        return try await apply(toJsonObjectIn: "get-custom-fields-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func collectionValue(forUserName userName: String) async throws -> CollectionValue {
        return try await apply(toJsonObjectIn: "get-collection-value-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func collectionFolders(forUserName userName: String) async throws -> CollectionFolders {
        return try await apply(toJsonObjectIn: "get-folders-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func collectionFolderInfo(forFolderID folderID: Int,
                                     userName: String) async throws -> CollectionFolder {
        return try await apply(toJsonObjectIn: "get-folder-metadata-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func createFolder(named folderName: String,
                             forUserName userName: String) async throws -> CollectionFolder {
        return try await apply(toJsonObjectIn: "post-create-folder-201",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func edit(_ folder: CollectionFolder,
                     forUserName userName: String) async throws -> CollectionFolder {
        return try await apply(toJsonObjectIn: "post-edit-folder-metadata-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func collectionItems(inFolderID folderID: Int,
                                userName: String,
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) async throws -> CollectionFolderItems {
        return try await apply(toJsonObjectIn: "get-items-in-folder-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    public func addItem(_ itemID: Int,
                        toFolderID folderID: Int,
                        userName: String) async throws -> CollectionItemInfo {
        return try await apply(toJsonObjectIn: "add-item-to-collection-folder-200",
                               error: DiscogsError.unknownUser(username: userName))
    }

    // MARK: - Search

    public func search(for queryString: String, type: String = "title") async throws -> SearchResults {
        return try await apply(toJsonObjectIn: "search-200",
                               error: DiscogsError.unknown(nil))
    }

}
