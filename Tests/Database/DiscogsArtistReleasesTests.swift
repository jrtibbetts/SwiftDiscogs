//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsArtistReleasesTests: DiscogsTestBase {
    
    func testDecodeArtistReleasesJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-artist-releases-200"))
    }

    func testFormatsSplitsMultipleValuesCorrectly() throws {
        let artistRelease: DiscogsArtistRelease = try discogsObject(inLocalJsonFileNamed: "get-artist-releases-200")

        if let formats = artistRelease.formats {
            XCTAssertTrue(formats.contains("CD"))
            XCTAssertTrue(formats.contains("EP"))
            XCTAssertEqual(formats.count, 2)
        } else {
            XCTFail("The release should have had 2 formats.")
        }
    }
    
    func testGetArtistReleasesNotFoundError() {
        assertDiscogsErrorMessage(in: "get-artist-releases-404", is: "Artist not found.")
    }

    fileprivate func assert(_ artistReleases: DiscogsReleaseSummaries) {
        XCTAssertEqual(artistReleases.releases.count, 3)

        let release = artistReleases.releases[0]
        XCTAssertEqual(release.artist, "Nickelback", "artist name")
        XCTAssertEqual(release.id, 173765, "release ID")
        XCTAssertEqual(release.role, "Main", "release role")
        XCTAssertEqual(release.title, "Curb", "release title")
        XCTAssertEqual(release.type, "master", "release type")
        XCTAssertEqual(release.year, 1996, "release year")

        let hesher = artistReleases.releases[1]

        if let formats = hesher.formats {
            XCTAssertTrue(formats.contains("CD"), "CD format")
            XCTAssertTrue(formats.contains("EP"), "EP format")
        } else {
            XCTFail("Release 2 should have CD & EP formats")
        }
    }
    
}
