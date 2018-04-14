//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import SwiftDiscogsApp
import XCTest

class CollectionAndTableArrayModelTests: XCTestCase {

    func testNumberOfItemsReturnsArrayCount() {
        let data = ["One", "two", "three", "four", "can", "I", "have", "a", "little", "more"]
        let model = CollectionAndTableArrayModel(data: data)
        XCTAssertEqual(model.numberOfItems(inSection: 0), data.count)
    }

}
