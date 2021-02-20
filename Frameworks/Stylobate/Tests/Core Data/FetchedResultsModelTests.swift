//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import CoreData
import XCTest

// swiftlint:disable force_cast

class FetchedResultsModelTests: FetchingTestBase, FetchedResultsProvider {

    // MARK: - FetchedResultsProvider

    typealias ManagedObjectType = Person

    // MARK: - FetchedResultsTableModel Tests

    func testTableModelNumberOfSectionsAndRows() throws {
        importTestData()

        let (tableView, model) = try tableAndModel()
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 14)
    }

    func testTableModelDeleteItem() throws {
        importTestData()

        let (tableView, model) = try tableAndModel()
        let path = IndexPath(row: 9, section: 0)
        XCTAssertFalse(model.tableView(tableView, canEditRowAt: path))
        model.tableView(tableView, commit: .delete, forRowAt: path)
        XCTAssertEqual(model.numberOfItems(in: 0), 13)
        tableView.reloadData()
        XCTAssertTrue(tableView.dataSource === model)
        XCTAssertEqual(model.tableView(tableView, numberOfRowsInSection: 0), 13)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 13)
    }

    func testTableModelCell() throws {
        importTestData()

        let (tableView, model) = try tableAndModel()
        let path = IndexPath(row: 9, section: 0)
        _ = model.tableView(tableView, cellForRowAt: path)
    }

    func testShowSectionIndex() throws {
        importTestData()

        let (tableView, model) = try tableAndModel()
        model.showSectionIndex = true
        XCTAssertNotNil(model.sectionIndexTitles(for: tableView))
    }

    func testHideSectionIndex() throws {
        importTestData()

        let (tableView, model) = try tableAndModel()
        model.showSectionIndex = false
        XCTAssertNil(model.sectionIndexTitles(for: tableView))
    }

    func tableAndModel() throws -> (UITableView, FetchedResultsTableModel) {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0))
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.sortDescriptors = []
        let frc = try fetchedResultsController(for: fetchRequest)!
        let model = FetchedResultsTableModel(tableView,
                                             context: testingContext!,
                                             fetchedResultsController: frc as! ManagedObjectFRC)
        tableView.dataSource = model

        return (tableView, model)
    }

    // MARK: - FetchedResultsCollectionModel Tests

    func testCollectionModelNumberOfSectionsAndItems() throws {
        importTestData()

        let (collectionView, model) = try collectionAndModel()
        XCTAssertTrue(collectionView.dataSource === model)
        XCTAssertEqual(collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 14)
    }

    func testCollectionModelCell() throws {
        importTestData()

        let (collectionView, model) = try collectionAndModel()
        let path = IndexPath(row: 9, section: 0)
        _ = model.collectionView(collectionView, cellForItemAt: path)
    }

    func collectionAndModel() throws -> (UICollectionView, FetchedResultsCollectionModel) {
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.sortDescriptors = []
        let frc = try fetchedResultsController(for: fetchRequest)
        let model = FetchedResultsCollectionModel(collectionView,
                                                  context: testingContext!,
                                                  fetchedResultsController: frc as! ManagedObjectFRC)
        collectionView.dataSource = model

        return (collectionView, model)
    }

}

// swiftlint:enable force_cast
