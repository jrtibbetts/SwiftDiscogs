//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsLabelTests: DiscogsTestBase {
    
    func testDiscogsLabelJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-label-200"))
    }
    
    func testGetLabelNotFoundError() {
        assertDiscogsErrorMessage(in: "get-label-404", is: "Label not found.")
    }
    
    fileprivate func assert(_ label: DiscogsLabel) {
        XCTAssertEqual(label.name, "Planet E", "label name")
        XCTAssertEqual(label.sublabels?.count, 2)
    }
    
}