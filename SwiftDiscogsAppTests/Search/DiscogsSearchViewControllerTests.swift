//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import SwiftDiscogs
import XCTest

class DiscogsSearchViewControllerTests: XCTestCase {

    var searchViewController: DiscogsSearchViewController?

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: DiscogsSearchViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        searchViewController = storyboard.instantiateViewController(withIdentifier: "discogsSearch") as? DiscogsSearchViewController
        _ = searchViewController?.view  // force viewDidLoad() to be called
    }

    func testSignInAndOutCallExpectedMethods() {
        searchViewController?.discogs = MockDiscogs()
        let signInExpectation = expectation(description: "Signing in to Discogs")

        searchViewController?.signInToDiscogs() {
            signInExpectation.fulfill()
        }

        wait(for: [signInExpectation], timeout: 2.0)

        let signOutExpectation = expectation(description: "Signing out of Discogs")

        searchViewController?.signOutOfDiscogs() {
            signOutExpectation.fulfill()
        }

        wait(for: [signOutExpectation], timeout: 2.0)
    }

    func testSignInAndSignOutTappedCallExpectedMethods() {
        // Sign in
        let signInExpectation = expectation(description: "Signing in to Discogs")
        searchViewController?.signInTapped(source: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            signInExpectation.fulfill()
        }

        wait(for: [signInExpectation], timeout: 5.0)

        // Sign out
        let signOutExpectation = expectation(description: "Signing out of Discogs")
        searchViewController?.signOutTapped(source: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            signOutExpectation.fulfill()
        }

        wait(for: [signOutExpectation], timeout: 5.0)
    }

}
