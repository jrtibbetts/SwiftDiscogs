//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import PromiseKit
import SwiftDiscogs
import XCTest

class DiscogsArtistViewControllerTests: XCTestCase {
    
    func testViewDidLoadWithValidArtistOk() {
        let exp = expectation(description: "artist")
        let bundle = Bundle(for: DiscogsArtistViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: "discogsArtist") as! DiscogsArtistViewController

        let client = MockDiscogs()
        let promise: Promise<DiscogsArtist> = client.artist(identifier: 42)
        promise.then { (artist) -> Void in
            controller.artist = artist
            _ = controller.view
            controller.viewDidLoad()
            XCTAssertNotNil(controller.display, "artist view")
            XCTAssertNotNil(controller.model, "artist model")
            XCTAssertNotNil(controller.model?.data, "artist")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

}
