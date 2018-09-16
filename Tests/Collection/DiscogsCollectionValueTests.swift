//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import XCTest

class DiscogsCollectionValueTests: DiscogsTestBase {
    
    func testDecodeCollectionValueJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-collection-value-200"))
    }
    
    fileprivate func assert(_ collectionValue: DiscogsCollectionValue) {
        XCTAssertEqual(collectionValue.minimum,  "$75.50")
        XCTAssertEqual(collectionValue.median,  "$100.25")
        XCTAssertEqual(collectionValue.maximum, "$250.00")
    }
    
}
