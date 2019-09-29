//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class ReleaseSummaryTests: DiscogsTestBase {
    
    func testDecodeArtistReleasesJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-release-summaries-200"))
    }

    func testFormatsSplitsMultipleValuesCorrectly() throws {
        let artistReleases: ReleaseSummaries = try discogsObject(inLocalJsonFileNamed: "get-release-summaries-200")

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

    func assert(_ artistReleases: ReleaseSummaries,
                file: StaticString = #file,
                line: UInt = #line) {
        guard let releases = artistReleases.releases else {
            XCTFail("There should be releases in the file.", file: file, line: line)

            return
        }

        XCTAssertEqual(releases.count, 3)

        let release = releases[0]
        XCTAssertEqual(release.artist, "Nickelback", "artist name", file: file, line: line)
        XCTAssertEqual(release.id, 173765, "release ID", file: file, line: line)
        XCTAssertEqual(release.role, "Main", "release role", file: file, line: line)
        XCTAssertEqual(release.title, "Curb", "release title", file: file, line: line)
        XCTAssertEqual(release.type, "master", "release type", file: file, line: line)
        XCTAssertEqual(release.year, 1996, "release year", file: file, line: line)

        let hesher = releases[1]

        if let formats = hesher.formats {
            XCTAssertTrue(formats.contains("CD"), "CD format", file: file, line: line)
            XCTAssertTrue(formats.contains("EP"), "EP format", file: file, line: line)
        } else {
            XCTFail("Release 2 should have CD & EP formats", file: file, line: line)
        }
    }
    
}
