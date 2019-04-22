//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class CollectionItemInfoTests: DiscogsTestBase {
    
    func testDecodeCollectionItemInfoJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "add-item-to-collection-folder-200"))
    }
    
    fileprivate func assert(_ item: CollectionItemInfo) {
        XCTAssertEqual(item.instanceId, 3)
        XCTAssertEqual(item.resourceUrl, "https://api.discogs.com/users/example/collection/folders/1/release/1/instance/3")
    }
    
}

