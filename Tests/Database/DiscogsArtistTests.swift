//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsArtistTests: DiscogsTestBase {
    
    func testDecodeArtistJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-artist-200"))
    }
    
    func testGetArtistNotFoundError() {
        assertDiscogsErrorMessage(in: "get-artist-404", is: "Artist not found.")
    }
    
    fileprivate func assert(_ artist: DiscogsArtist) {
        XCTAssertEqual(artist.id, 108713, "artist ID")
        XCTAssertEqual(artist.namevariations![0], "Nickleback", "artist name")
        XCTAssertEqual(artist.images!.count, 2, "artist images")
        XCTAssertEqual(artist.members!.count, 5, "band members")
        
        let shittyMember = artist.members![0]
        XCTAssertEqual(shittyMember.active, true, "is band member still active")
        XCTAssertEqual(shittyMember.id, 270222, "band member ID")
        XCTAssertEqual(shittyMember.name, "Chad Kroeger")
    }
    
}
