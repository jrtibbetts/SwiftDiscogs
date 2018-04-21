//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A combined `UITableView` and `UICollectionView` data model and delegate. By
/// default, it assumes that any collection view and table view that it's
/// attached to will have the same number of sections and items in each section.
/// Subclasses need only override `collectionView(:cellForItemAt:)`,
/// `tableView(:cellForRowAt:)`, `numberOfSections()`,
/// `numberOfItems(inSection:)`, and, if needed, `headerTitle(forSection:)`.
/// The model has a generic `data` property which, although it's not used in
/// this class directly, should be used by model subclasses to determine how
/// many sections and items in each section there are.
open class CollectionAndTableModel: NSObject, Model,
    UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate {

    override public init() {
        super.init()
    }

    // MARK: UICollectionViewDataSource
    
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    // MARK: UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    open func tableView(_ tableView: UITableView,
                        titleForHeaderInSection section: Int) -> String? {
        return headerTitle(forSection: section)
    }
    
    // MARK: Other functions to be overridden by subclasses

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
