//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class ReleaseTests: DiscogsTestBase {

    func testDecodeReleaseJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-release-200"))
    }

    func testGetReleaseNotFoundError() {
        assertDiscogsErrorMessage(in: "get-release-404", is: "Release not found.")
    }

    func assert(_ releaseVersion: Release,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(releaseVersion.title, "Never Gonna Give You Up", file: file, line: line)
        XCTAssertEqual(releaseVersion.dataQuality, "Correct", file: file, line: line)
        XCTAssertEqual(releaseVersion.community?.contributors[0].username,
                       "memory", "Username",
                       file: file,
                       line: line)
    }

}
