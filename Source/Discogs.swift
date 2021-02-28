//  Copyright © 2017 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit
import UIKit

/// Error types for problems retrieving data from Discogs.
public enum DiscogsError: Error {

    /// Thrown when no artist was found when searching by its ID.
    case artistNotFoundById(Int)

    case discogsResponse(ErrorResponse)

    case labelNotFoundById(Int)

    /// Thrown when no artist was found when searching by its name.
    case masterReleaseNotFoundById(Int)
    case releaseNotFoundById(Int)
    case unauthenticatedUser
    case unknownUser(username: String)
    case unknown(Error?)

}

/// Implemented by clients of a Discogs API server.
public protocol Discogs {

    // MARK: - User Identify

    var isSignedIn: Bool { get }

    func authorize(presentingViewController: UIViewController,
                   callbackUrlString: String) -> Promise<OAuthSwiftCredential>

    func signOut()

    func userIdentity() -> Promise<UserIdentity>

    func userProfile(userName: String) -> Promise<UserProfile>

    // MARK: - Database

    /// Look up the artist with the specified ID and invoke the completion on
    /// it.
    ///
    /// - parameter identifier: The numeric ID of the artist.
    /// - parameter completion: The completion block that will be applied to
    ///   the artist, if found, or the error, if one was thrown.
    func artist(identifier: Int) -> Promise<Artist>

    /// Look up the releases by the specified artist's ID.
    ///
    /// - parameter artistId: The numeric ID of the artist.
    /// - parameter completion: The completion block that will be applied to
    ///   all of the artist's releases, or to the error, if one was thrown.
    func releases(forArtist artistId: Int) -> Promise<ReleaseSummaries>

    /// Look up the record label by its ID.
    ///
    /// - parameter identifier: The label's unique ID.
    /// - parameter completion: The completion block that will be applied to
    ///   the label, or to the error, if one was thrown.
    func label(identifier: Int) -> Promise<RecordLabel>

    /// Look up the record label's releases by the label's name.
    ///
    /// - parameter labelId: The label's unique ID.
    /// - parameter completion: The completion block that will be applied to
    ///   all of the label's releases, or to the error, if one was thrown.
    func releases(forLabel labelId: Int) -> Promise<ReleaseSummaries>

    /// Process a master release with a specified ID.
    ///
    /// - parameter identifier: The unique ID of the master release.
    /// - parameter completion: The completion block that will be applied to
    ///   the master release, or to the error, if one was thrown.
    func masterRelease(identifier: Int) -> Promise<MasterRelease>

    /// Process all of the release versions that belong to a master release.
    ///
    /// - parameter identifier: The unique ID of the master release.
    /// - parameter pageNumber: The number of the page (i.e. batch).
    func releasesForMasterRelease(_ identifier: Int,
                                  pageNumber: Int,
                                  resultsPerPage: Int) -> Promise<MasterReleaseVersions>

    /// Process a release with a specified ID.
    ///
    /// - parameter identifier: The unique ID of the release.
    /// - parameter completion: The completion block that will be applied to
    ///   the release, or to the error, if one was thrown.
    func release(identifier: Int) -> Promise<Release>

    // MARK: - Collections

    func customCollectionFields(forUserName: String) -> Promise<CollectionCustomFields>
    func collectionValue(forUserName: String) -> Promise<CollectionValue>
    func collectionFolders(forUserName: String) -> Promise<CollectionFolders>
    func collectionFolderInfo(forFolderID: Int,
                              userName: String) -> Promise<CollectionFolder>
    func createFolder(named: String,
                      forUserName: String) -> Promise<CollectionFolder>
    func edit(_ folder: CollectionFolder,
              forUserName: String) -> Promise<CollectionFolder>
    func collectionItems(inFolderID: Int,
                         userName: String,
                         pageNumber: Int,
                         resultsPerPage: Int) -> Promise<CollectionFolderItems>
    func addItem(_ itemId: Int,
                 toFolderID: Int,
                 userName: String) -> Promise<CollectionItemInfo>

    // MARK: - Search

    func search(for queryString: String,
                type: String) -> Promise<SearchResults>

    func search(forArtist artistName: String) -> Promise<SearchResults>
}

public enum DiscogsSearchType: String {

    case artist

}

public extension Discogs {

    func search(forArtist artistName: String) -> Promise<SearchResults> {
        return search(for: artistName, type: DiscogsSearchType.artist.rawValue)
    }

}
