//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import SwiftDiscogsApp
import XCTest

class DiscogsSearchResultsModelTests: XCTestCase {
    
    func testCellForRowAtIndexPathReturnsCorrectCellType() {
        let exp = expectation(description: "search results")
        let discogs = MockDiscogs()
        _ = discogs.search(for: "doesn't matter").then { (searchResults) -> Void in
            XCTAssertEqual(searchResults.results?.count, 3)
            let model = DiscogsSearchResultsModel(data: searchResults.results)
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
