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
    
    fileprivate func assert(_ labelReleases: ReleaseSummaries) {
        guard let release3 = labelReleases.releases?[2] else {
            XCTFail("There should be at least 3 releases in the file.")
            return
        }
        
        XCTAssertEqual(release3.artist, "Innerzone Orchestra", "release artist name")
        XCTAssertEqual(release3.year, 1999, "release year")
    }
    
}

