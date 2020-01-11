//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class ArtistTests: DiscogsTestBase {

    func testDecodeArtistJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-artist-200"))
    }

    func testGetArtistNotFoundError() {
        assertDiscogsErrorMessage(in: "get-artist-404", is: "Artist not found.")
    }

    func assert(_ artist: Artist,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(artist.id, 108713, "artist ID", file: file, line: line)
        XCTAssertEqual(artist.namevariations![0], "Nickleback", "artist name", file: file, line: line)
        XCTAssertEqual(artist.images!.count, 2, "artist images", file: file, line: line)
        XCTAssertEqual(artist.members!.count, 5, "band members", file: file, line: line)

        let shittyMember = artist.members![0]
        XCTAssertEqual(shittyMember.active, true, "is band member still active", file: file, line: line)
        XCTAssertEqual(shittyMember.id, 270222, "band member ID", file: file, line: line)
        XCTAssertEqual(shittyMember.name, "Chad Kroeger", file: file, line: line)
    }

}
