//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import XCTest

class MockSearchDisplay: DiscogsSearchDisplay {

    var setUpCalled = false
    var signedInAsCalled = false
    var signedOutCalled = false
    var willSignInCalled = false
    var willSignOutCalled = false

    func setUp(searchController: UISearchController, navigationItem: UINavigationItem) {
        setUpCalled = true
    }

    func signedInAs(userName: String) {
        signedInAsCalled = true
    }

    func signedOut() {
        signedOutCalled = true
    }

    func willSignIn() {
        willSignInCalled = true
    }

    func willSignOut() {
        willSignOutCalled = true
    }

}

class DiscogsSearchViewControllerTests: XCTestCase {

    var searchViewController: DiscogsSearchViewController!
    var mockSearchDisplay: MockSearchDisplay!

    override func setUp() {
        super.setUp()

        searchViewController = DiscogsSearchViewController()
        mockSearchDisplay = MockSearchDisplay()
        searchViewController.display = mockSearchDisplay
        searchViewController.discogs = MockDiscogs()
    }

    func testSignInAndOutCallExpectedMethods() {
        let signInExpectation = expectation(description: "Signing in to Discogs")

        searchViewController.signInToDiscogs() {
            XCTAssertTrue(self.mockSearchDisplay.willSignInCalled)
            XCTAssertTrue(self.mockSearchDisplay.signedInAsCalled)
            XCTAssertFalse(self.mockSearchDisplay.willSignOutCalled)
            XCTAssertFalse(self.mockSearchDisplay.signedOutCalled)
            signInExpectation.fulfill()
        }

        wait(for: [signInExpectation], timeout: 2.0)

        let signOutExpectation = expectation(description: "Signing out of Discogs")

        searchViewController.signOutOfDiscogs() {
            XCTAssertTrue(self.mockSearchDisplay.willSignOutCalled)
            XCTAssertTrue(self.mockSearchDisplay.signedOutCalled)
            signOutExpectation.fulfill()
        }

        wait(for: [signOutExpectation], timeout: 2.0)
    }

}
