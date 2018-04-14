//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

open class CollectionAndTableArrayModel<E>: CollectionAndTableModel<[E]> {

    open var dataArray: [E]? {
        didSet {
            data = dataArray
        }
    }

    open override func numberOfSections() -> Int {
        return 1
    }

    open override func numberOfItems(inSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
}
