//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
@testable import SwiftDiscogsApp
import XCTest

class DiscogsArtistModelTests: XCTestCase {

     var discogsClient = MockDiscogs()

    func testInitializerWithArtist() {
        let artist = discogsClient.artist(identifier: 99).then { (artist) -> Void in
            let model = DiscogsArtistModel(artist: artist)
            XCTAssertEqual(model.artist, artist)
        }
    }
    
}
