//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class CollectionItemInfoTests: DiscogsTestBase {
    
    func testDecodeCollectionItemInfoJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "add-item-to-collection-folder-200"))
    }
    
    func assert(_ item: CollectionItemInfo,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(item.instanceId, 3, file: file, line: line)
        XCTAssertEqual(item.resourceUrl,
                       "https://api.discogs.com/users/example/collection/folders/1/release/1/instance/3",
                       file: file,
                       line: line)
    }
    
}

