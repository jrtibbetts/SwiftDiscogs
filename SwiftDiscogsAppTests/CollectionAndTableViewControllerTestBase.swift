//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import XCTest

class CollectionAndTableViewControllerTestBase: ControllerTestBase {

    var tableView: UITableView? {
        return (viewController?.display as? CollectionAndTableDisplay)?.tableView
    }

    var collectionView: UICollectionView? {
        return (viewController?.display as? CollectionAndTableDisplay)?.collectionView
    }

}
