//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsCollectionItemInfoTests: DiscogsTestBase {
    
    func testDecodeCollectionItemInfoJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "add-item-to-collection-folder-200"))
    }
    
    fileprivate func assert(_ item: DiscogsCollectionItemInfo) {
        XCTAssertEqual(item.instance_id, 3)
        XCTAssertEqual(item.resource_url, "https://api.discogs.com/users/example/collection/folders/1/release/1/instance/3")
    }
    
}

