//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import PromiseKit
import SwiftDiscogs
import XCTest

class DiscogsArtistViewControllerTests: CollectionAndTableViewControllerTestBase {

    var artistViewController: DiscogsArtistViewController? {
        return viewController as? DiscogsArtistViewController
    }

    var artistView: DiscogsArtistView? {
        return artistViewController?.artistView
    }

    var artistModel: DiscogsArtistModel? {
        return artistViewController?.artistModel
    }

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: DiscogsArtistViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        viewController = storyboard.instantiateViewController(withIdentifier: "discogsArtist") as? Controller
        XCTAssertNotNil(viewController)
        _ = viewController?.view // force viewDidLoad() to be called
    }

    func testModelAndDisplayOutletsAreProperlyConnected() {
        XCTAssertNotNil(artistModel)  // check non-nil and correct type
        XCTAssertNotNil(artistView)   // check non-nil and correct type
        XCTAssertTrue(artistView?.model === artistModel)
    }

    func testModelIsDataSource() {
        XCTAssertTrue(tableView?.delegate === artistModel)
        XCTAssertTrue(tableView?.dataSource === artistModel)
    }

    // MARK: UITableViewDataSource

    func testTableViewNumberOfSectionsIs2() {
        XCTAssertEqual(tableView?.numberOfSections, 2)
    }

    func testNumberOfRowsInTableSection1Is1() {
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1)
    }

    func testCellForTableAtIndexReturnsExpectedCell() {
        guard let model = artistModel, let tableView = artistView?.tableView else {
            XCTFail("Expected the model to be a DiscogsArtistModel and the display to be a DiscogsArtistView.")
            return
        }

        let cell = model.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        guard let bioCell = cell as? DiscogsArtistBioTableCell else {
            XCTFail("The cell at (0, 0) should be a DiscogsArtistBioTableCell.")
            return
        }

        XCTAssertNil(bioCell.bioText)
        XCTAssertNil(bioCell.bioLabel)

        bioCell.bioText = "This is a sample biography."

        XCTAssertEqual(bioCell.bioLabel?.text, bioCell.bioText)
    }

}
