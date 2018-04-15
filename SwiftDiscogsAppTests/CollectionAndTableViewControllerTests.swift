//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogsApp
import XCTest

class CollectionAndTableViewControllerTests: XCTestCase {

    func testViewDidLoadSetsDataSourcesAndDelegates() {
        let data = "foo"
        let model = CollectionAndTableModel(data: data)
        let display = CollectionAndTableDisplay<String>()
        // Don't just call display.tableView = UITableView() because the
        // display's property is weak.
        let tableView = UITableView(frame: CGRect())
        display.tableView = tableView
        // Same goes for collection views.
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        display.collectionView = collectionView
        let controller = CollectionAndTableViewController<String>()
        controller.display = display
        controller.model = model
        XCTAssertNil(display.model)

        controller.viewDidLoad()
        XCTAssertTrue(display.model === controller.model)
        XCTAssertTrue(display.tableView?.delegate === model)
        XCTAssertTrue(display.tableView?.dataSource === model)
        XCTAssertTrue(display.collectionView?.delegate === model)
        XCTAssertTrue(display.collectionView?.dataSource === model)
    }
    
}
