//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import PromiseKit
import XCTest

class MockDiscogsTests: DiscogsTestBase {

    // MARK: - Database

    func testArtistById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.artist(identifier: 0))
    }

    func testArtistByIdInErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.artist(identifier: 0))
    }

    func testLabelById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.label(identifier: 0))
    }

    func testLabelByIdErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.label(identifier: 300))
    }

    func testLabelReleasesById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.releases(forLabel: 300))
    }

    func testLabelReleasesByIdErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.releases(forLabel: 200))
    }

    func testMasterReleaseById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.masterRelease(identifier: 0))
    }

    func testMasterReleaseByIdErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.masterRelease(identifier: 9))
    }

    func testReleasesForMasterReleaseById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.releasesForMasterRelease(0))
    }

    func testReleasesForMasterReleaseByIdErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.releasesForMasterRelease(0))
    }

    func testReleaseById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.release(identifier: 0))
    }

    func testReleaseByIdErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.release(identifier: 9))
    }

    func testReleasesForArtistById() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.releases(forArtist: 0))
    }

    func testReleasesForArtistByIdErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.releases(forArtist: 0))
    }

    func testSearch() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.search(for: "Queen", type: "artist"))
    }

    func testSearchErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.search(for: "Queen", type: "artist"))
    }

    // MARK: - Collections

    func testCustomCollectionFields() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.customCollectionFields(for: "James Joyce"))
    }

    func testCustomCollectionFieldsErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.customCollectionFields(for: "James Joyce"))
    }

    func testCollectionValue() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.collectionValue(for: "Herman Melville"))
    }

    func testCollectionValueErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.collectionValue(for: "Herman Melville"))
    }

    func testCollectionFolders() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.collectionFolders(for: "Virginia Woolf"))
    }

    func testCollectionFoldersErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.collectionFolders(for: "Virginia Woolf"))
    }

    func testCollectionFolderInfo() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.collectionFolderInfo(forFolderId: 99, userName: "Kurt Vonnegut"))
    }

    func testCollectionFolderInfoErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.collectionFolderInfo(forFolderId: 99, userName: "Kurt Vonnegut"))
    }

    func testCreateFolder() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.createFolder(named: "Funk", userName: "Edgar Allen Poe"))
    }

    func testCreateFolderErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.createFolder(named: "Funk", userName: "Edgar Allen Poe"))
    }

    func testEditFolder() {
        let discogs = MockDiscogs()
        let folder = DiscogsCollectionFolder(id: 99,
                                             count: 3,
                                             name: "Junk",
                                             resourceUrl: "https://api.discogs.com/foo")
        assert(validPromise: discogs.edit(folder, userName: "H. P. Lovecraft"))
    }

    func testEditFolderErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        let folder = DiscogsCollectionFolder(id: 99,
                                             count: 3,
                                             name: "Junk",
                                             resourceUrl: "https://api.discogs.com/foo")
        assert(invalidPromise: discogs.edit(folder, userName: "H. P. Lovecraft"))
    }

    func testCollectionItemsForFolder() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.collectionItems(forFolderId: 909, userName: "John Fogerty"))
    }

    func testCollectionItemsForFolderErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.collectionItems(forFolderId: 909, userName: "John Fogerty"))
    }

    func testAddItemToFolder() {
        let discogs = MockDiscogs()
        assert(validPromise: discogs.addItem(234512324, toFolderId: 12, userName: "Jimi Hendrix"))
    }

    func testAddItemToFolderErrorMode() {
        let discogs = MockDiscogs(errorMode: true)
        assert(invalidPromise: discogs.addItem(234512324, toFolderId: 12, userName: "Jimi Hendrix"))
    }

}
