//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsReleaseTests: DiscogsTestBase {
    
    func testDecodeReleaseJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-release-200"))
    }
    
    func testGetReleaseNotFoundError() {
        assertDiscogsErrorMessage(in: "get-release-404", is: "Release not found.")
    }
    
    fileprivate func assert(_ releaseVersion: DiscogsRelease) {
        XCTAssertEqual(releaseVersion.title, "Never Gonna Give You Up")
        XCTAssertEqual(releaseVersion.dataQuality, "Correct")
        XCTAssertEqual(releaseVersion.community?.contributors[0].username, "memory", "Username")
    }
    
}

