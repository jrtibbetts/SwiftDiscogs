//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import UIKit

open class FetchedResultsCollectionModel: FetchedResultsModel,
    UICollectionViewDataSource,
    UICollectionViewDelegate {

    weak var collectionView: UICollectionView!

    public init(_ collectionView: UICollectionView,
                context: NSManagedObjectContext,
                fetchedResultsController: ManagedObjectFRC) {
        self.collectionView = collectionView
        super.init(context: context, fetchedResultsController: fetchedResultsController)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate

    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(in: section)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
