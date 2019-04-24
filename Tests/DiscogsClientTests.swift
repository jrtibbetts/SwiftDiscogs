//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import PromiseKit
import XCTest

class DiscogsClientTests: DiscogsTestBase {

    var unauthorizedClient: DiscogsClient!
    var userAgent: String!

    override func setUp() {
        super.setUp()

        userAgent = "Mozilla/5.0 SwiftDiscogsTests (https://github.com/jrtibbetts/SwiftDiscogs)"
        unauthorizedClient = DiscogsClient(consumerKey: "one",
                                           consumerSecret: "two",
                                           userAgent: userAgent)
    }

    func testInitializerWithNonsenseValuesOk() {
        XCTAssertEqual(unauthorizedClient.userAgent, userAgent)
    }

    // MARK: - Database Tests

    func testArtistWithValidIdOk() {
        let artistId = 42895    // Sinéad O'Connor, of course
        let failureMessage = "Expected Discogs artist \(artistId) to be valid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<Artist> = unauthorizedClient.artist(identifier: artistId)
        promise.done { (artist) in
            XCTAssertEqual(artist.name, "Sinéad O'Connor")
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage)
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testArtistWithInvalidIdFails() {
        let artistId = -2389
        let failureMessage = "Expected Discogs artist \(artistId) to be invalid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<Artist> = unauthorizedClient.artist(identifier: artistId)
        promise.done { (artist) in
            XCTFail(failureMessage)
            }.catch { (error) in
                exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testLabelWithValidIdOk() {
        let labelId = 3198    // Chrysalis
        let failureMessage = "Expected Discogs label \(labelId) to be valid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<RecordLabel> = unauthorizedClient.label(identifier: labelId)
        promise.done { (label) in
            XCTAssertEqual(label.name, "Chrysalis")
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage + "; \(error.localizedDescription)")
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testLabelWithInvalidIdFails() {
        let labelId = -1564
        let failureMessage = "Expected Discogs label \(labelId) to be invalid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<Artist> = unauthorizedClient.artist(identifier: labelId)
        promise.done { (label) in
            XCTFail(failureMessage)
            }.catch { (error) in
                exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testMasterReleaseWithValidIdOk() {
        let masterId = 51559    // "Mandinka"
        let failureMessage = "Expected Discogs master release \(masterId) to be valid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<MasterRelease> = unauthorizedClient.masterRelease(identifier: masterId)
        promise.done { (masterRelease) in
            XCTAssertEqual(masterRelease.title, "Mandinka")
            XCTAssertEqual(masterRelease.id, masterId)
            XCTAssertEqual(masterRelease.year, 1987)
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage)
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testMasterReleaseWithInvalidIdFails() {
        let masterId = -1616
        let failureMessage = "Expected Discogs master release \(masterId) to be invalid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<MasterRelease> = unauthorizedClient.masterRelease(identifier: masterId)
        promise.done { (masterRelease) in
            XCTFail(failureMessage)
            }.catch { (error) in
                exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleaseWithValidIdOk() {
        let releaseId = 565113    // "Mandinka" UK 12"
        let failureMessage = "Expected Discogs release \(releaseId) to be valid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<Release> = unauthorizedClient.release(identifier: releaseId)
        promise.done { (release) in
            XCTAssertEqual(release.title, "Mandinka")
            XCTAssertEqual(release.id, releaseId)
            XCTAssertEqual(release.year, 1987)
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage)
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleaseWithInvalidIdFails() {
        let releaseId = -1616
        let failureMessage = "Expected Discogs release \(releaseId) to be invalid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<Release> = unauthorizedClient.release(identifier: releaseId)
        promise.done { (release) in
            XCTFail(failureMessage)
            }.catch { (error) in
                exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleasesForArtistWithValidIdOk() {
        let artistId = 42895    // Sinéad O'Connor
        let failureMessage = "Expected Discogs artist \(artistId) to have some releases"
        let exp = expectation(description: failureMessage)
        let promise: Promise<ReleaseSummaries> = unauthorizedClient.releases(forArtist: artistId)
        promise.done { (summaries) in
            XCTAssertNotNil(summaries.pagination)
            XCTAssertTrue(summaries.pagination!.items >= 116)
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage)
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleasesForArtistWithInvalidIdFails() {
        let artistId = -909
        let failureMessage = "Expected Discogs artist \(artistId) to be invalid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<ReleaseSummaries> = unauthorizedClient.releases(forArtist: artistId)
        promise.done { (summaries) in
            XCTFail(failureMessage)
            }.catch { (error) in
                exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleasesForLabelWithValidIdOk() {
        let labelId = 3198    // Chrysalis
        let failureMessage = "Expected Discogs label \(labelId) to have some releases"
        let exp = expectation(description: failureMessage)
        let promise: Promise<ReleaseSummaries> = unauthorizedClient.releases(forLabel: labelId)
        promise.done { (summaries) in
            XCTAssertNotNil(summaries.pagination)
            XCTAssertTrue(summaries.pagination!.items >= 16000)
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage)
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleasesForLabelWithInvalidIdFails() {
        let labelId = -909
        let failureMessage = "Expected Discogs label \(labelId) to be invalid"
        let exp = expectation(description: failureMessage)
        let promise: Promise<ReleaseSummaries> = unauthorizedClient.releases(forLabel: labelId)
        promise.done { (summaries) in
            XCTFail(failureMessage)
            }.catch { (error) in
                exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func testReleasesForMasterReleaseWithValidIdOk() {
        let masterReleaseId = 51559    // "Mandinka"
        let failureMessage = "Expected Discogs master release \(masterReleaseId) to have some releases"
        let exp = expectation(description: failureMessage)
        let promise: Promise<MasterReleaseVersions> = unauthorizedClient.releasesForMasterRelease(masterReleaseId)
        promise.done { (summaries) in
            XCTAssertNotNil(summaries.pagination)
            XCTAssertTrue(summaries.pagination!.items >= 20)
            exp.fulfill()
            }.catch { (error) in
                XCTFail(failureMessage)
        }
        wait(for: [exp], timeout: 5.0)
    }

    // MARK: - Collection Tests

    func testCustomCollectionFieldsBeforeAuthenticationFails() {
        let promise: Promise<CollectionCustomFields> = unauthorizedClient.customCollectionFields(forUserName: "foo")
        assertUnauthorizedCallFails(promise: promise, description: "custom collection fields")
    }

    func testCollectionValueBeforeAuthenticationFails() {
        let promise: Promise<CollectionValue> = unauthorizedClient.collectionValue(forUserName: "foo")
        assertUnauthorizedCallFails(promise: promise, description: "collection value")
    }

    func testCollectionFoldersBeforeAuthenticationFails() {
        let promise: Promise<CollectionFolders> = unauthorizedClient.collectionFolders(forUserName: "foo")
        assertUnauthorizedCallFails(promise: promise, description: "collection folders")
    }

    func testCollectionFolderInfoBeforeAuthenticationFails() {
        let promise: Promise<CollectionFolder> = unauthorizedClient.collectionFolderInfo(forFolderID: 99, userName: "foo")
        assertUnauthorizedCallFails(promise: promise, description: "collection folder info")
    }

    func testCollectionFolderItemsBeforeAuthenticationFails() {
        let promise: Promise<CollectionFolderItems> = unauthorizedClient.collectionItems(inFolderID: 99, userName: "foo")
        assertUnauthorizedCallFails(promise: promise, description: "collection items")
    }

    func assertUnauthorizedCallFails<T: Codable>(promise: Promise<T>,
                                                 description: String) {
        let exp = expectation(description: "The call should fail if the caller hasn't authenticated yet")

        promise.done { (fields) in
            XCTFail("\(description) should have failed if the caller hasn't authenticated yet.")
            }.catch { (error) in
                exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

}
