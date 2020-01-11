//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class LabelReleasesTests: DiscogsTestBase {

    func testDiscogsLabelReleasesJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-label-releases-200"))
    }

    func testGetLabelReleasesNotFoundError() {
        assertDiscogsErrorMessage(in: "get-label-releases-404", is: "Label not found.")
    }

    func assert(_ labelReleases: ReleaseSummaries,
                file: StaticString = #file,
                line: UInt = #line) {
        guard let release3 = labelReleases.releases?[2] else {
            XCTFail("There should be at least 3 releases in the file.", file: file, line: line)
            return
        }

        XCTAssertEqual(release3.artist, "Innerzone Orchestra", "release artist name", file: file, line: line)
        XCTAssertEqual(release3.year, 1999, "release year", file: file, line: line)
    }

}
