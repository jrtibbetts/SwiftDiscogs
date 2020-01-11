//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class CollectionFolderItemsTests: DiscogsTestBase {

    func testDecodeCollectionValueJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-items-in-folder-200"))
    }

    func assert(_ items: CollectionFolderItems,
                file: StaticString = #file,
                line: UInt = #line) {
        guard let releases = items.releases else {
            XCTFail("The folder item's releases array shouldn't be nil.", file: file, line: line)
            return
        }

        XCTAssertEqual(releases.count, 2)
    }

}
