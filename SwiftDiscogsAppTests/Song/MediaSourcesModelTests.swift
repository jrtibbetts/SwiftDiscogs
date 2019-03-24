//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import XCTest

class MediaSourcesModelTests: XCTestCase {

    func testNewModelHasNoSources() {
        let model = MediaSourcesModel(sources: [])
        XCTAssertEqual(model.sources.count, 0)
    }

    func testModelWithOneSource() {
        let source = MediaSource(name: "Spotify", iconURL: nil)
        let model = MediaSourcesModel(sources: [source])
        XCTAssertEqual(model.sources.count, 1)
    }

}
