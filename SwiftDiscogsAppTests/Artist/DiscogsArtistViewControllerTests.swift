//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import PromiseKit
import Stylobate
import SwiftDiscogs
import XCTest

class DiscogsArtistViewControllerTests: XCTestCase {

    var viewController: DiscogsArtistViewController?

    var artistView: DiscogsArtistView? {
        return viewController?.artistView
    }

    var artistModel: DiscogsArtistModel? {
        return viewController?.artistModel
    }

    var discogs = MockDiscogs()

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: DiscogsArtistViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        viewController = storyboard.instantiateViewController(withIdentifier: "discogsArtist") as? DiscogsArtistViewController
        viewController?.discogs = discogs
        XCTAssertNotNil(viewController)
        _ = viewController?.view // force viewDidLoad() to be called
    }

    func testModelAndDisplayOutletsAreProperlyConnected() {
        XCTAssertNotNil(artistModel)  // check non-nil and correct type
        XCTAssertNotNil(artistView)   // check non-nil and correct type
        XCTAssertTrue(artistView?.model === artistModel)
    }

    func testModelIsDataSource() {
        XCTAssertTrue(viewController?.artistView.tableView?.dataSource === artistModel)
    }

    class MockArtistDisplay: DiscogsArtistView {

        var wasRefreshed: Bool = false

        override func refresh() {
            super.refresh()
            wasRefreshed = true
        }
    }

    // MARK: UITableViewDataSource

    func testTableViewNumberOfSectionsWhenArtistIsNilIs0() {
        XCTAssertEqual(viewController?.artistView.tableView?.numberOfSections, 0)
    }

    func testTableViewNumberOfSectionsWithArtistBioAndNoReleasesIs1() {
        var artist = Artist(name: "The Beatles")
        artist.profile = """
        This is a non-empty profile, which should trigger the addition of a bio section.
        """
        artistModel?.artist = artist
        XCTAssertEqual(viewController?.artistView.tableView?.numberOfSections, 1)
        XCTAssertEqual(viewController?.artistView.tableView?.numberOfRows(inSection: 0), 1)
    }

    func testTableViewNumberOfSectionsWithArtistReleasesAndNoBio() {
        let artist = Artist(name: "The Beatles")
        artistModel?.artist = artist
        artistModel?.releases = []
        XCTAssertEqual(viewController?.artistView.tableView?.numberOfSections, 1)
        XCTAssertEqual(viewController?.artistView.tableView?.numberOfRows(inSection: 0), 0)
    }

    func testCellForTableAtIndexReturnsExpectedCell() {
        guard let model = artistModel, let tableView = artistView?.tableView else {
            XCTFail("Expected the model to be a DiscogsArtistModel and the display to be a DiscogsArtistView.")
            return
        }

        var artist = Artist(name: "The Beatles")
        artist.profile = """
This is a non-empty profile, which should trigger the addition of a bio section.
"""
        model.artist = artist
        model.releases = []

        let cell = model.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        guard let bioCell = cell as? DiscogsArtistBioTableCell else {
            XCTFail("The cell at (0, 0) should be a DiscogsArtistBioTableCell.")
            return
        }

        XCTAssertEqual(bioCell.bioText, artist.profile)

        bioCell.bioText = "This is a sample biography."

        XCTAssertNotNil(bioCell.bioText)
    }

    func testTableSectionHeadersOk() {
        let exp = expectation(description: "MockDiscogs().artist was called")
        _ = viewController?.view  // force viewDidLoad() to be called
        discogs.artist(identifier: 99).done { [weak self] (artist) in
            self?.viewController?.artist = artist

            guard let table = self?.artistView?.tableView else {
                XCTFail("Failed to find a tableView in the artist view.")
                return
            }

            var artist = Artist(name: "The Beatles")
            artist.profile = """
            This is a non-empty profile, which should trigger the addition of a bio section.
            """
            self?.artistModel?.artist = artist
            self?.artistModel?.releases = []

            let bioTitle = self?.artistModel?.tableView(table, titleForHeaderInSection: 0)
            XCTAssertNil(bioTitle)

            let releasesTitle = self?.artistModel?.tableView(table, titleForHeaderInSection: 1)
            XCTAssertEqual(releasesTitle, "Releases")

            exp.fulfill()
            }.catch { (error) in
                XCTFail("Unexpected error: \(error.localizedDescription)")
        }

        wait(for: [exp], timeout: 3.0)
    }

}
