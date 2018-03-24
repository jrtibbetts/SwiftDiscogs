@testable import SwiftDiscogs
import XCTest

class DiscogsUserIdentityTests: DiscogsTestBase {
    
    func testDecodeUserIdentityJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-user-identity-200"))
    }
    
    func testGetUserIdentityUnauthorizedError() {
        assertDiscogsErrorMessage(in: "get-user-identity-401", is: "You must authenticate to access this resource.")
    }
    
    fileprivate func assert(_ userIdentity: DiscogsUserIdentity) {
        XCTAssertEqual(1, userIdentity.identifier)
        XCTAssertEqual("example", userIdentity.username)
        XCTAssertEqual("Your Application Name", userIdentity.consumerName)
    }
    
}
