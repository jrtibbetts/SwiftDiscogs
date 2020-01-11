//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class MasterReleaseTests: DiscogsTestBase {

    func testDecodeMasterReleaseJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-master-200"))
    }

    func testGetMasterReleaseNotFoundError() {
        assertDiscogsErrorMessage(in: "get-master-404", is: "Master Release not found.")
    }

    func assert(_ masterRelease: MasterRelease,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(masterRelease.title, "Stardiver", file: file, line: line)
        XCTAssertEqual(masterRelease.year, 1997, file: file, line: line)
    }

}
