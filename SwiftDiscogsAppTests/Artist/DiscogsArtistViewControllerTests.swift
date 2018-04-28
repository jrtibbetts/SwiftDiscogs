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

    var discogs = MockDiscogs()

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: DiscogsArtistViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        viewController = storyboard.instantiateViewController(withIdentifier: "discogsArtist") as? Controller
        artistViewController?.discogs = discogs
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

    func testSetArtistRefreshesView() {
        let mockDisplay = MockArtistDisplay()
        XCTAssertFalse(mockDisplay.refreshWasCalled)

        let exp = expectation(description: "setting the artist")
        artistViewController?.display = mockDisplay
        discogs.artist(identifier: 99).then { (artist) -> Void in
            self.artistViewController?.artist = artist
            exp.fulfill()
        }

        wait(for: [exp], timeout: 3.0)
    }

    func testSetArtistSearchResultRefreshesView() {
        let mockDisplay = MockArtistDisplay()
        artistViewController?.discogs = discogs
        XCTAssertFalse(mockDisplay.refreshWasCalled)

        let searchResultExp = expectation(description: "setting the artist search result")
        artistViewController?.display = mockDisplay
        discogs.search(for: "John Lennon", type: "Artist").then { (artistSearchResults) -> Void in
            self.artistViewController?.artistSearchResult = artistSearchResults.results?.first
            XCTAssertNotNil(self.artistViewController?.artistSearchResult)

            searchResultExp.fulfill()
        }

        wait(for: [searchResultExp], timeout: 3.0)

        let artistExp = expectation(description: "setting the artist")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            XCTAssertNotNil(self.artistViewController?.artist)
            artistExp.fulfill()
        }

        wait(for: [artistExp], timeout: 3.0)
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

    func testTableSectionHeadersOk() {
        let exp = expectation(description: "MockDiscogs().artist was called")
        _ = artistViewController?.view  // force viewDidLoad() to be called
        discogs.artist(identifier: 99).then { (artist) -> Void in
            self.artistViewController?.artist = artist

            guard let table = self.artistView?.tableView else {
                XCTFail("Failed to find a tableView in the artist view.")
                return
            }

            let bioSection = DiscogsArtistModel.Section.bio
            let bioTitle = self.artistModel?.tableView(table, titleForHeaderInSection: bioSection.rawValue)
            XCTAssertEqual(bioTitle, "Bio")

            let releasesSection = DiscogsArtistModel.Section.releases
            let releasesTitle = self.artistModel?.tableView(table, titleForHeaderInSection: releasesSection.rawValue)
            XCTAssertEqual(releasesTitle, "Releases")

            exp.fulfill()
        }

        wait(for: [exp], timeout: 3.0)
    }

}
