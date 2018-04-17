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

    func testCollectionCellForRowIsAlwaysDefaultCell() {
        let model = CollectionAndTableModel(data: "whatever")
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        let path = IndexPath(item: 99, section: 100)
        let cell = model.collectionView(collectionView, cellForItemAt: path)
        XCTAssertTrue(type(of: cell) == UICollectionViewCell.self)
    }

    func testTableCellForRowIsAlwaysDefaultCell() {
        let model = CollectionAndTableModel(data: "whatever")
        let tableView = UITableView()
        let path = IndexPath(item: 99, section: 100)
        let cell = model.tableView(tableView, cellForRowAt: path)
        XCTAssertTrue(type(of: cell) == UITableViewCell.self)
    }

    func testTableTitleForHeaderIsNil() {
        let data = "Data string"
        let model = CollectionAndTableModel(data: data)
        XCTAssertNil(model.headerTitle(forSection: 0))
    }

}
