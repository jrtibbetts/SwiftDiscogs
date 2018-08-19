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

}
