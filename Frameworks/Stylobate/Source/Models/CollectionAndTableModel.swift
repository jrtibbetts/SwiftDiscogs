//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A combined `UITableView` and `UICollectionView` data model. Subclasses
//// need only override `collectionView(:cellForItemAt:)`,
/// `tableView(:cellForRowAt:)`, `numberOfSections()`,
/// `numberOfItems(inSection:)`, and, if needed, `headerTitle(forSection:)`.
open class CollectionAndTableModel: NSObject {

    // MARK: Functions to be overridden by subclasses

    open func headerTitle(forSection section: Int) -> String? {
        return nil
    }

    open func numberOfItems(inSection section: Int) -> Int {
        return 0
    }

    open func numberOfSections() -> Int {
        return 0
    }

}

// MARK: UICollectionViewDataSource

extension CollectionAndTableModel: UICollectionViewDataSource {

    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return MissingCollectionViewCell(frame: CGRect())
    }

    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

}

// MARK: UITableViewDataSource

extension CollectionAndTableModel: UITableViewDataSource {

    open func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MissingTableViewCell()
    }

    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    open func tableView(_ tableView: UITableView,
                        titleForHeaderInSection section: Int) -> String? {
        return headerTitle(forSection: section)
    }
}
