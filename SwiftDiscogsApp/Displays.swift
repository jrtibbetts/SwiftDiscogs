//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public protocol CollectionDisplay {
    
    var collectionView: UICollectionView? { get set }
    
    func refresh()
    
}

public protocol TableDisplay {

    var tableView: UITableView? { get set }

    func refresh()

}

public protocol LotsOfThingsDisplay: CollectionDisplay, TableDisplay {

}
