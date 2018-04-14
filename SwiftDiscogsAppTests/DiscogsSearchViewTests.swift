//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import XCTest

class DiscogsSearchViewTests: XCTestCase {

    var discogsSearchView: DiscogsSearchView!

    var signInButton: UIButton {
        return discogsSearchView!.signInButton!
    }

    var signOutButton: UIButton {
        return discogsSearchView!.signOutButton!
    }

    var signOutView: UIView {
        return discogsSearchView!.signOutView!
    }

    var signedInAsLabel: UILabel {
        return discogsSearchView!.signedInAsLabel!
    }

    override func setUp() {
        super.setUp()

        let appBundle = Bundle(for: DiscogsSearchResultsController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: appBundle)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "discogsSearch") as? DiscogsSearchViewController
        discogsSearchView = searchViewController?.view as? DiscogsSearchView
        XCTAssertNotNil(discogsSearchView)
        XCTAssertNotNil(discogsSearchView.signInButton)
        XCTAssertNotNil(discogsSearchView.signOutView)
        XCTAssertNotNil(discogsSearchView.signOutButton)
        XCTAssertNotNil(discogsSearchView.signedInAsLabel)
        XCTAssertFalse(discogsSearchView.searchBarShouldBeginEditing(UISearchBar()))
    }

    func testSignInButtonIsInitiallyShown() {
        XCTAssertFalse(signInButton.isHidden)
        XCTAssertTrue(signOutView.isHidden)
    }

    func testSuccessfulSignInHidesSignInButtonAndShowsSignOutView() {
        let userName = "Charles Rennie Mackintosh"
        discogsSearchView.signedInAs(userName: userName)
        XCTAssertTrue(signInButton.isHidden)
        XCTAssertFalse(signOutView.isHidden)
        XCTAssertEqual(signedInAsLabel.text, "Signed in as \(userName).")
        XCTAssertTrue(discogsSearchView.searchBarShouldBeginEditing(UISearchBar()))
    }

    func testSignInAndOutShowsSignInButtonAgain() {
        discogsSearchView.signedInAs(userName: "foo")
        discogsSearchView.signedOut()
        XCTAssertFalse(signInButton.isHidden)
        XCTAssertTrue(signOutView.isHidden)
        XCTAssertFalse(discogsSearchView.searchBarShouldBeginEditing(UISearchBar()))
    }

    func testTearDownDoesNothing() {
        discogsSearchView.tearDown()
    }

}
