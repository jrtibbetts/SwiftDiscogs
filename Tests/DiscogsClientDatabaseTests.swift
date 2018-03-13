//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import PromiseKit
import XCTest

class DiscogsClientDatabaseTests: DiscogsTestBase {

    var unauthorizedClient: DiscogsClient!
    var userAgent: String!

    override func setUp() {
        super.setUp()

        userAgent = "Mozilla/5.0 SwiftDiscogsTests (https://github.com/jrtibbetts/SwiftDiscogs)"
        unauthorizedClient = DiscogsClient(consumerKey: "one",
                                           consumerSecret: "two",
                                           userAgent: userAgent,
                                           callbackUrl: URL(string: "https://api.discogs.com")!)
    }

    func testInitializerWithNonsenseValuesOk() {
        XCTAssertEqual(unauthorizedClient.userAgent, userAgent)
    }

    func testArtistWithValidIdOk() {
        let artistId = 42895    // Sinéad O'Connor, of course
        let exp = expectation(description: "Expected Discogs artist \(artistId) to be valid")
        let promise: Promise<DiscogsArtist> = unauthorizedClient.artist(id: artistId)
        promise.then { (artist) -> Void in
            XCTAssertEqual(artist.name, "Sinéad O'Connor")
            exp.fulfill()
            }.catch { (error) in
                XCTFail("Expected Discogs artist \(artistId) to be valid")
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testArtistWithInvalidIdFails() {
        let artistId = -2389
        let exp = expectation(description: "Expected Discogs artist \(artistId) to be invalid")
        let promise: Promise<DiscogsArtist> = unauthorizedClient.artist(id: artistId)
        promise.then { (artist) -> Void in
            XCTFail("Expected Discogs artist \(artistId) to be invalid")
            }.catch { (error) in
                exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testLabelWithValidIdOk() {
        let labelId = 3198    // Chrysalis
        let exp = expectation(description: "Expected Discogs label \(labelId) to be valid")
        let promise: Promise<DiscogsLabel> = unauthorizedClient.label(id: labelId)
        promise.then { (label) -> Void in
            XCTAssertEqual(label.name, "Chrysalis")
            exp.fulfill()
            }.catch { (error) in
                XCTFail("Expected Discogs label \(labelId) to be valid")
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testLabelWithInvalidIdFails() {
        let labelId = -1564
        let exp = expectation(description: "Expected Discogs label \(labelId) to be invalid")
        let promise: Promise<DiscogsArtist> = unauthorizedClient.artist(id: labelId)
        promise.then { (label) -> Void in
            XCTFail("Expected Discogs label \(labelId) to be invalid")
            }.catch { (error) in
                exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

}
