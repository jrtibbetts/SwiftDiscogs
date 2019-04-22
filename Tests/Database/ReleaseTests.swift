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
    
    fileprivate func assert(_ releaseVersion: Release) {
        XCTAssertEqual(releaseVersion.title, "Never Gonna Give You Up")
        XCTAssertEqual(releaseVersion.dataQuality, "Correct")
        XCTAssertEqual(releaseVersion.community?.contributors[0].username, "memory", "Username")
    }
    
}

