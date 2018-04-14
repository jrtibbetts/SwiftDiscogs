//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import SwiftDiscogsApp
import XCTest

class CollectionAndTableModelTests: XCTestCase {
    
    func testInitializerWithNilDataHasZeroSections() {
        let data: Any? = nil
        let model = CollectionAndTableModel(data: data)
        let expectedItems = 0
        XCTAssertEqual(model.numberOfSections(), expectedItems)
    }

    func testInitializerWithNonNilDataHasOneSection() {
        let data = "Data string"
        let model = CollectionAndTableModel(data: data)
        XCTAssertNotNil(data)
        let expectedItems = 1
        XCTAssertEqual(model.numberOfSections(), expectedItems)
    }

    func testTableTitleForHeaderIsNil() {
        let data = "Data string"
        let model = CollectionAndTableModel(data: data)
        XCTAssertNil(model.headerTitle(forSection: 0))
    }

}
