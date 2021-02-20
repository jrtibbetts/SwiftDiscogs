//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class CollectionAndTableModelTests: XCTestCase {

    func testCollectionViewCreatedProgrammaticallyHasNoRowsOrSections() {
        let model = CollectionAndTableModel()
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        assertCollectionIsEmptyAndReturnsMissingCell(collectionView: collectionView, model: model)
    }

    func testTableViewCreatedProgrammaticallyHasNoRowsOrSections() {
        let model = CollectionAndTableModel()
        let tableView = UITableView(frame: CGRect())
        assertTableIsEmptyAndReturnsMissingCell(tableView: tableView, model: model)
    }

    // MARK: - Header Titles & Views

    func testHeaderTitleAndViewReturnNilByDefault() {
        let model = CollectionAndTableModel()
        let tableView = UITableView(frame: CGRect())
        XCTAssertNil(model.tableView(tableView, titleForHeaderInSection: 0))
    }

    // MARK: Test Fixtures

    func assertCollectionIsEmptyAndReturnsMissingCell(collectionView: UICollectionView,
                                                      model: CollectionAndTableModel) {
        let path = IndexPath(item: 0, section: 0)
        let cell = model.collectionView(collectionView, cellForItemAt: path)
        XCTAssertTrue(cell.isMember(of: MissingCollectionViewCell.self))
        XCTAssertEqual(model.numberOfSections(in: collectionView), 0)
        XCTAssertEqual(model.collectionView(collectionView, numberOfItemsInSection: 0), 0)
    }

    func assertTableIsEmptyAndReturnsMissingCell(tableView: UITableView,
                                                 model: CollectionAndTableModel) {
        let path = IndexPath(item: 0, section: 0)
        let cell = model.tableView(tableView, cellForRowAt: path)
        XCTAssertTrue(cell.isMember(of: MissingTableViewCell.self))
        XCTAssertEqual(model.numberOfSections(in: tableView), 0)
        XCTAssertEqual(model.tableView(tableView, numberOfRowsInSection: 0), 0)
        XCTAssertNil(model.tableView(tableView, titleForHeaderInSection: 0))
    }

}
