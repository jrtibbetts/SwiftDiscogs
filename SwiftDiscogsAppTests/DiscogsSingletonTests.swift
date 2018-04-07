//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsSingletonTests: XCTestCase {
    
    func testInitialValuesOk() {
        guard let client = DiscogsClient.singleton else {
            XCTFail("The DiscogsClient.singleton should be non-nil.")
            return
        }

        XCTAssertEqual(client.userAgent, "Mozilla/5.0; SwiftDiscogsApp (https://github.com/jrtibbetts/SwiftDiscogs)")
    }

    func testThatThereReallyIsOnlyOneInstance() {
        XCTAssertTrue(DiscogsClient.singleton === DiscogsClient.singleton)
    }

}
