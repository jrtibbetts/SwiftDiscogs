//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsReleaseSummaryTests: DiscogsTestBase {
    
    func testDecodeArtistReleasesJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-release-summaries-200"))
    }

    func testFormatsSplitsMultipleValuesCorrectly() throws {
        let artistReleases: DiscogsReleaseSummaries = try discogsObject(inLocalJsonFileNamed: "get-release-summaries-200")

        guard let releaseSummary = artistReleases.releases?[1] else {
            XCTFail("There should have been at least 2 releases.")
            return
        }

        if let formats = releaseSummary.formats {
            XCTAssertTrue(formats.contains("CD"))
            XCTAssertTrue(formats.contains("EP"))
            XCTAssertEqual(formats.count, 2)
        } else {
            XCTFail("The release should have had 2 formats.")
        }
    }
    
    func testGetArtistReleasesNotFoundError() {
        assertDiscogsErrorMessage(in: "get-release-summaries-404", is: "Artist not found.")
    }

    fileprivate func assert(_ artistReleases: DiscogsReleaseSummaries) {
        guard let releases = artistReleases.releases else {
            XCTFail("There should be releases in the file.")

            return
        }

        XCTAssertEqual(releases.count, 3)

        let release = releases[0]
        XCTAssertEqual(release.artist, "Nickelback", "artist name")
        XCTAssertEqual(release.id, 173765, "release ID")
        XCTAssertEqual(release.role, "Main", "release role")
        XCTAssertEqual(release.title, "Curb", "release title")
        XCTAssertEqual(release.type, "master", "release type")
        XCTAssertEqual(release.year, 1996, "release year")

        let hesher = releases[1]

        if let formats = hesher.formats {
            XCTAssertTrue(formats.contains("CD"), "CD format")
            XCTAssertTrue(formats.contains("EP"), "EP format")
        } else {
            XCTFail("Release 2 should have CD & EP formats")
        }
    }
    
}
