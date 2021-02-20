//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

// swiftlint:disable force_cast

class CollectionAndTableDisplayTests: XCTestCase {

    let nib = UINib(nibName: "CollectionAndTableDisplayTests",
                    bundle: StylobateTests.resourceBundle)

    var collectionAndTableView: CollectionAndTableDisplay {
        // Get a new instance every time. Tests should grab it once only.
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CollectionAndTableDisplay
    }

    var collectionOnlyView: CollectionAndTableDisplay {
        // Get a new instance every time. Tests should grab it once only.
        return nib.instantiate(withOwner: nil, options: nil)[1] as! CollectionAndTableDisplay
    }

    var tableOnlyView: CollectionAndTableDisplay {
        // Get a new instance every time. Tests should grab it once only.
        return nib.instantiate(withOwner: nil, options: nil)[2] as! CollectionAndTableDisplay
    }

    var noOutletsView: CollectionAndTableDisplay {
        // Get a new instance every time. Tests should grab it once only.
        return nib.instantiate(withOwner: nil, options: nil)[3] as! CollectionAndTableDisplay
    }

    // MARK: - Collection and Table

    func testCollectionAndTableInitialForegroundModeIsTable() {
        let view = collectionAndTableView
        XCTAssertEqual(view.foregroundMode, .table)
        XCTAssertNotNil(view.foregroundView)

        XCTAssertTrue(view.foregroundView === view.tableView)
        XCTAssertNil(view.indexPathForSelectedItem)
        XCTAssertNil(view.indexPathsForSelectedItems)
    }

    func testCollectionAndTableViewToggleForegroundPutsCollectionInForeground() {
        let view = collectionAndTableView
        view.toggleForegroundView()
        XCTAssertEqual(view.foregroundMode, .collection)
        XCTAssertTrue(view.foregroundView === view.collectionView)
    }

    func testCollectionAndTableViewToggleForegroundTwicePutsTableInForeground() {
        let view = collectionAndTableView
        view.toggleForegroundView()
        assert(shown: view.collectionView!, hidden: view.tableView!)

        view.toggleForegroundView()
        XCTAssertEqual(view.foregroundMode, .table)
        XCTAssertTrue(view.foregroundView === view.tableView)
        assert(shown: view.tableView!, hidden: view.collectionView!)
    }

    func testCollectionAndTableViewSetForegroundModeShowsAndHides() {
        let view = collectionAndTableView

        view.foregroundMode = .collection
        assert(shown: view.collectionView!, hidden: view.tableView!)

        view.foregroundMode = .table
        assert(shown: view.tableView!, hidden: view.collectionView!)
    }

    // MARK: - Collection Only

    func testCollectionOnlyInitialForegroundModeIsCollection() {
        let view = collectionOnlyView
        assertSingleViewInitialForegroundMode(view: view,
                                              expectedForegroundView: view.collectionView!,
                                              expectedMode: .collection)
        XCTAssertNotNil(view.indexPathsForSelectedItems)
        XCTAssertTrue(view.indexPathsForSelectedItems!.isEmpty)
    }

    func testCollectionOnlyViewToggleForegroundChangesNothing() {
        let view = collectionOnlyView
        assertSingleViewToggleForegroundChangesNothing(view: view,
                                                       expectedView: view.collectionView!,
                                                       expectedMode: .collection)
    }

    func testCollectionOnlyViewSetForegroundModeDoesNothing() {
        let view = collectionOnlyView
        assertSingleViewSetForegroundModeDoesNothing(view: view,
                                                     hiddenView: view.collectionView!,
                                                     expectedMode: .collection)
    }

    // MARK: - Table Only

    func testTableOnlyInitialForegroundModeIsTable() {
        let view = tableOnlyView
        assertSingleViewInitialForegroundMode(view: view,
                                              expectedForegroundView: view.tableView!,
                                              expectedMode: .table)
        XCTAssertNil(view.indexPathsForSelectedItems)
    }

    func assertSingleViewInitialForegroundMode(view: CollectionAndTableDisplay,
                                               expectedForegroundView: UIView,
                                               expectedMode: CollectionAndTableDisplay.ForegroundMode) {
        XCTAssertEqual(view.foregroundMode, expectedMode)
        XCTAssertNotNil(view.foregroundView)
        XCTAssertTrue(view.foregroundView === expectedForegroundView)
        XCTAssertNil(view.indexPathForSelectedItem)
        XCTAssertFalse(expectedForegroundView.isHidden)
    }

    func testTableOnlyToggleForegroundChangesNothing() {
        let view = tableOnlyView
        assertSingleViewToggleForegroundChangesNothing(view: view,
                                                       expectedView: view.tableView!,
                                                       expectedMode: .table)
    }

    func testTableOnlyViewSetForegroundModeDoesNothing() {
        let view = tableOnlyView
        assertSingleViewSetForegroundModeDoesNothing(view: view,
                                                     hiddenView: view.tableView!,
                                                     expectedMode: .table)
    }
    func testNoOutletViewHasTableForegroundModeAndNilSelectedIndices() {
        let view = noOutletsView
        XCTAssertEqual(view.foregroundMode, .table)
        XCTAssertNil(view.indexPathForSelectedItem)
        XCTAssertNil(view.indexPathsForSelectedItems)
    }

    // MARK: - Fixtures

    func assert(shown: UIView,
                hidden: UIView,
                line: UInt = #line) {
        XCTAssertFalse(shown.isHidden, line: line)
        XCTAssertTrue(hidden.isHidden, line: line)
    }

    func assertSingleViewToggleForegroundChangesNothing(view: CollectionAndTableDisplay,
                                                        expectedView: UIView,
                                                        expectedMode: CollectionAndTableDisplay.ForegroundMode) {
        view.toggleForegroundView()
        XCTAssertEqual(view.foregroundMode, expectedMode)
        XCTAssertTrue(view.foregroundView === expectedView)
        XCTAssertFalse(expectedView.isHidden)
    }

    func assertSingleViewSetForegroundModeDoesNothing(view: CollectionAndTableDisplay,
                                                      hiddenView: UIView,
                                                      expectedMode: CollectionAndTableDisplay.ForegroundMode) {
        view.foregroundMode = .collection
        XCTAssertEqual(view.foregroundMode, expectedMode)
        XCTAssertFalse(hiddenView.isHidden)

        view.foregroundMode = .table
        XCTAssertEqual(view.foregroundMode, expectedMode)
        XCTAssertFalse(hiddenView.isHidden)
    }

}

// swiftlint:enable force_cast
