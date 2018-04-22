//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import SwiftDiscogs
import XCTest

class DiscogsSearchResultsViewControllerTests: CollectionAndTableViewControllerTestBase {

    var resultsViewController: DiscogsSearchResultsController? {
        return viewController as? DiscogsSearchResultsController
    }

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: DiscogsSearchResultsController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        viewController = storyboard.instantiateViewController(withIdentifier: "discogsSearchResults") as? DiscogsSearchResultsController
        _ = viewController?.view  // force viewDidLoad() to be called
    }

    func testViewDidLoadConnectsTableAndControllerOk() {
        XCTAssertNotNil(resultsViewController?.searchResultsView)
        XCTAssertNotNil(resultsViewController?.searchResultsModel)
    }

    func testSearchUpdatesTableOk() {
        let exp = expectation(description: "artist results update")
        resultsViewController?.discogs = MockDiscogs()
        resultsViewController?.updateSearchResults(for: UISearchController(searchResultsController: viewController))

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            XCTAssertEqual(self.resultsViewController?.searchResultsModel?.numberOfItems(inSection: 0), 10)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testCellForRowAtIndexPathReturnsCorrectCellType() {
        let exp = expectation(description: "search results")
        let discogs = MockDiscogs()
        _ = discogs.search(for: "doesn't matter").then { (searchResults) -> Void in
            XCTAssertEqual(searchResults.results?.count, 3)
            let model = DiscogsSearchResultsModel(results: searchResults.results)
            let indexPath = IndexPath(item: 2, section: 0)
            let tableView = UITableView()
            tableView.register(ArtistSearchResultCell.self, forCellReuseIdentifier: "artistSearchResultCell")
            let cell = model.tableView(tableView, cellForRowAt: indexPath)

            guard let artistCell = cell as? ArtistSearchResultCell else {
                XCTFail("Expected an ArtistSearchResultCell to be returned.")
                return
            }

            XCTAssertEqual(artistCell.artistName, "Nirvana - Nevermind")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

}
