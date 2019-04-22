//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class CollectionFolderItemsTests: DiscogsTestBase {
    
    func testDecodeCollectionValueJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "collection-folder-items-200"))
    }
    
    fileprivate func assert(_ items: CollectionFolderItems) {
        guard let releases = items.releases else {
            XCTFail("The folder item's releases array shouldn't be nil.")
            return
        }
        
        XCTAssertEqual(releases.count, 2)
    }
    
}

