@testable import SwiftDiscogs
import XCTest

class UserIdentityTests: DiscogsTestBase {
    
    func testDecodeUserIdentityJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-user-identity-200"))
    }
    
    func testGetUserIdentityUnauthorizedError() {
        assertDiscogsErrorMessage(in: "get-user-identity-401", is: "You must authenticate to access this resource.")
    }
    
    func assert(_ userIdentity: UserIdentity,
                file: StaticString = #file,
                line: UInt = #line) {
        XCTAssertEqual(1, userIdentity.id, file: file, line: line)
        XCTAssertEqual("example", userIdentity.username, file: file, line: line)
        XCTAssertEqual("Your Application Name", userIdentity.consumerName, file: file, line: line)
    }
    
}
