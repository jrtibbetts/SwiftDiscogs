//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import Stylobate
import XCTest

class CollectionAndTableViewControllerTestBase<ViewController: CollectionAndTableViewController>: XCTestCase {

    var viewController: ViewController?

    var tableView: UITableView? {
        return (viewController?.display as? CollectionAndTableDisplay)?.tableView
    }

    var collectionView: UICollectionView? {
        return (viewController?.display as? CollectionAndTableDisplay)?.collectionView
    }

}
