//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class CollectionAndTableViewControllerTests: XCTestCase {

    lazy var viewController: CollectionAndTableViewController = {
        let storyboard = UIStoryboard(name: "CollectionAndTableTests", bundle: StylobateTests.resourceBundle)
        // swiftlint:disable force_cast
        let viewController = storyboard.instantiateInitialViewController() as! CollectionAndTableViewController
        // swiftlint:enable force_cast
        viewController.model = CollectionAndTableModel()

        return viewController
    }()

    func testLoadFromStoryboardOk() {
        _ = viewController.view
        // swiftlint:disable force_cast
        let display = viewController.display as! TestCollectionAndTableDisplay
        // swiftlint:enable force_cast
        let initialRefreshCount = display.refreshCount
        display.refresh()
        XCTAssertEqual(display.refreshCount, initialRefreshCount + 1)
    }

}

class TestCollectionAndTableDisplay: CollectionAndTableDisplay {

    var refreshCount = 0

    override func refresh() {
        super.refresh()
        refreshCount += 1
    }

}
