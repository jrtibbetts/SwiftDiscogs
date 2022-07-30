//  Copyright © 2017 Poikile Creations. All rights reserved.

import OAuthSwift
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
                   callbackUrlString: String) async -> OAuthSwiftCredential

    func signOut()

    func userIdentity() async -> UserIdentity

    func userProfile(userName: String) async -> UserProfile

    // MARK: - Database

    /// Look up the artist with the specified ID and invoke the completion on
    /// it.
    ///
    /// - parameter identifier: The numeric ID of the artist.
    /// - parameter completion: The completion block that will be applied to
    ///   the artist, if found, or the error, if one was thrown.
    func artist(identifier: Int) async -> Artist

    /// Look up the releases by the specified artist's ID.
    ///
    /// - parameter artistId: The numeric ID of the artist.
    /// - parameter completion: The completion block that will be applied to
    ///   all of the artist's releases, or to the error, if one was thrown.
    func releases(forArtist artistId: Int) async -> ReleaseSummaries

    /// Look up the record label by its ID.
    ///
    /// - parameter identifier: The label's unique ID.
    /// - parameter completion: The completion block that will be applied to
    ///   the label, or to the error, if one was thrown.
    func label(identifier: Int) async -> RecordLabel

    /// Look up the record label's releases by the label's name.
    ///
    /// - parameter labelId: The label's unique ID.
    /// - parameter completion: The completion block that will be applied to
    ///   all of the label's releases, or to the error, if one was thrown.
    func releases(forLabel labelId: Int) async -> ReleaseSummaries

    /// Process a master release with a specified ID.
    ///
    /// - parameter identifier: The unique ID of the master release.
    /// - parameter completion: The completion block that will be applied to
    ///   the master release, or to the error, if one was thrown.
    func masterRelease(identifier: Int) async -> MasterRelease

    /// Process all of the release versions that belong to a master release.
    ///
    /// - parameter identifier: The unique ID of the master release.
    /// - parameter pageNumber: The number of the page (i.e. batch).
    func releasesForMasterRelease(_ identifier: Int,
                                  pageNumber: Int,
                                  resultsPerPage: Int) async -> MasterReleaseVersions

    /// Process a release with a specified ID.
    ///
    /// - parameter identifier: The unique ID of the release.
    /// - parameter completion: The completion block that will be applied to
    ///   the release, or to the error, if one was thrown.
    func release(identifier: Int) async -> Release

    // MARK: - Collections

    func customCollectionFields(forUserName: String) async -> CollectionCustomFields
    func collectionValue(forUserName: String) async -> CollectionValue
    func collectionFolders(forUserName: String) async -> CollectionFolders
    func collectionFolderInfo(forFolderID: Int,
                              userName: String) async -> CollectionFolder
    func createFolder(named: String,
                      forUserName: String) async -> CollectionFolder
    func edit(_ folder: CollectionFolder,
              forUserName: String) async -> CollectionFolder
    func collectionItems(inFolderID: Int,
                         userName: String,
                         pageNumber: Int,
                         resultsPerPage: Int) async -> CollectionFolderItems
    func addItem(_ itemId: Int,
                 toFolderID: Int,
                 userName: String) async -> CollectionItemInfo

    // MARK: - Search

    func search(for queryString: String,
                type: String) async -> SearchResults

    func search(forArtist artistName: String) async -> SearchResults
}

public enum DiscogsSearchType: String {

    case artist

}

public extension Discogs {

    func search(forArtist artistName: String) async -> SearchResults {
        return await search(for: artistName, type: DiscogsSearchType.artist.rawValue)
    }

}
