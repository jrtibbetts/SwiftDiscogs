//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

open class CollectionAndTableModel: NSObject,
    UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate {
    
    open var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
            collectionView?.delegate = self
        }
    }
    
    open var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    @objc public func collectionView(_ collectionView: UICollectionView,
                                     cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    @objc public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView,
                                     numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    // MARK: UITableViewDataSource
    
    @objc public func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @objc public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    @objc public func tableView(_ tableView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    open func tableView(_ tableView: UITableView,
                        titleForHeaderInSection section: Int) -> String? {
        return headerTitle(forSection: section)
    }
    
    // MARK: Other functions to be overridden by subclasses
    
    open func numberOfItems(inSection section: Int) -> Int {
        return -1
    }
    
    open func numberOfSections() -> Int {
        return -1
    }
    
    open func headerTitle(forSection section: Int) -> String? {
        return nil
    }
    
}
