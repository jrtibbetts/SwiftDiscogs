//  Copyright © 2017 nrith. All rights reserved.

import Foundation
import PromiseKit

/// Error types for problems retrieving data from Discogs.
public enum DiscogsError: Error {
    
    /// Thrown when no artist was found when searching by its ID.
    case artistNotFoundById(Int)
    
    case discogsResponse(DiscogsErrorResponse)
    
    case labelNotFoundById(Int)
    
    /// Thrown when no artist was found when searching by its name.
    case masterReleaseNotFoundById(Int)
    case releaseNotFoundById(Int)
    case unauthenticatedUser()
    case unknownUser(username: String)
    case unknown(Error?)
}

/// Implemented by clients of a Discogs API server.
public protocol Discogs {
    
    // MARK: - Database
    
    /// Look up the artist with the specified ID and invoke the completion on
    /// it.
    ///
    /// - parameter id: The numeric ID of the artist.
    /// - parameter completion: The completion block that will be applied to
    ///   the artist, if found, or the error, if one was thrown.
    func artist(id: Int) -> Promise<DiscogsArtist>
    
    /// Look up the releases by the specified artist's ID.
    ///
    /// - parameter artistId: The numeric ID of the artist.
    /// - parameter completion: The completion block that will be applied to
    ///   all of the artist's releases, or to the error, if one was thrown.
    func releases(forArtist artistId: Int) -> Promise<DiscogsReleaseSummaries>
    
    /// Look up the record label by its ID.
    ///
    /// - parameter id: The label's unique ID.
    /// - parameter completion: The completion block that will be applied to
    ///   the label, or to the error, if one was thrown.
    func label(id: Int) -> Promise<DiscogsLabel>
    
    /// Look up the record label's releases by the label's name.
    ///
    /// - parameter labelId: The label's unique ID.
    /// - parameter completion: The completion block that will be applied to
    ///   all of the label's releases, or to the error, if one was thrown.
    func releases(forLabel labelId: Int) -> Promise<DiscogsReleaseSummaries>
    
    /// Process a master release with a specified ID.
    ///
    /// - parameter id: The unique ID of the master release.
    /// - parameter completion: The completion block that will be applied to
    ///   the master release, or to the error, if one was thrown.
    func masterRelease(id: Int) -> Promise<DiscogsMasterRelease>
    
    /// Process all of the release versions that belong to a master release.
    ///
    /// - parameter id: The unique ID of the master release.
    /// - parameter pageNumber: The number of the page (i.e. batch).
    func releasesForMasterRelease(id: Int,
                                  pageNumber: Int,
                                  resultsPerPage: Int) -> Promise<DiscogsMasterReleaseVersions>
    
    /// Process a release with a specified ID.
    ///
    /// - parameter id: The unique ID of the release.
    /// - parameter completion: The completion block that will be applied to
    ///   the release, or to the error, if one was thrown.
    func release(id: Int) -> Promise<DiscogsRelease>
    
    // MARK: - Collections
    
    func customCollectionFields(for userName: String) -> Promise<DiscogsCollectionCustomFields>
    func collectionValue(for userName: String) -> Promise<DiscogsCollectionValue>
    func collectionFolders(for userName: String) -> Promise<DiscogsCollectionFolders>
    func collectionFolderInfo(for folderId: Int,
                              userName: String) -> Promise<DiscogsCollectionFolder>
    func createFolder(named folderName: String,
                      userName: String) -> Promise<DiscogsCollectionFolder>
    func edit(_ folder: DiscogsCollectionFolder,
              userName: String) -> Promise<DiscogsCollectionFolder>
    func collectionItems(forFolderId folderId: Int,
                         userName: String,
                         pageNumber: Int,
                         resultsPerPage: Int) -> Promise<DiscogsCollectionFolderItems>
    func addItem(_ itemId: Int,
                 toFolderId folderId: Int,
                 userName: String) -> Promise<DiscogsCollectionItemInfo>
    
    func search(for queryString: String,
                type: String) -> Promise<DiscogsSearchResults>
    
}
