//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import XCTest

class CollectionValueTests: DiscogsTestBase {

    func testDecodeCollectionValueJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-collection-value-200"))
    }

    func assert(_ collectionValue: CollectionValue,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(collectionValue.minimum, "$75.50", file: file, line: line)
        XCTAssertEqual(collectionValue.median, "$100.25", file: file, line: line)
        XCTAssertEqual(collectionValue.maximum, "$250.00", file: file, line: line)
    }

}
