//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import XCTest

class UserProfileTests: DiscogsTestBase {
    
    func testDecodeUserProfileJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-user-profile-200"))
    }
    
    func assert(_ userProfile: UserProfile,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(1578108, userProfile.id, file: file, line: line)
        XCTAssertEqual("2012-08-15T21:13:36-07:00", userProfile.registered, file: file, line: line)
        XCTAssertEqual(100, userProfile.buyerRating, file: file, line: line)
    }
    
}
