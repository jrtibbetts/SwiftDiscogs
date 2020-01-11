//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class LabelTests: DiscogsTestBase {

    func testDiscogsLabelJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-label-200"))
    }

    func testGetLabelNotFoundError() {
        assertDiscogsErrorMessage(in: "get-label-404", is: "Label not found.")
    }

    func assert(_ label: RecordLabel,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(label.name, "Planet E", "label name", file: file, line: line)
        XCTAssertEqual(label.sublabels?.count, 2, file: file, line: line)
    }

}
