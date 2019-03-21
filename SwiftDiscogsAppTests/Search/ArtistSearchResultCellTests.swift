//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import Stylobate
import SwiftDiscogs
import XCTest

class ArtistSearchResultCellTests: XCTestCase {

    func testSetNonNilSearchResult() {
        let exp = expectation(description: "The mock client should return search results")

        _ = MockDiscogs().search(for: "foo").done { (results) in
            let cell = ArtistSearchResultCell()
            cell.searchResult = results.results?[0]
            XCTAssertEqual(cell.artistName, "Nirvana - Nevermind")
            XCTAssertEqual(cell.thumbnailUrlString, "")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func testSetNilSearchResult() {
        let cell = ArtistSearchResultCell()
        cell.searchResult = nil
        XCTAssertNil(cell.artistName)
        XCTAssertNil(cell.thumbnailUrlString)
    }

}
