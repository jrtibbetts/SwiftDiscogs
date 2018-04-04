//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class DiscogsUserProfileTests: DiscogsTestBase {
    
    func testDecodeUserProfileJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-user-profile-200"))
    }
    
    fileprivate func assert(_ userProfile: DiscogsUserProfile) {
        XCTAssertEqual(1578108, userProfile.id)
        XCTAssertEqual("2012-08-15T21:13:36-07:00", userProfile.registered)
        XCTAssertEqual(100, userProfile.buyerRating)
    }
    
}
