//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

open class CollectionAndTableArrayModel<E>: CollectionAndTableModel<[E]> {

    // MARK: CollectionAndTableModel

    open override func numberOfItems(inSection section: Int) -> Int {
        if let data = data, section == 0 {
            return data.count
        } else {
            return 0
        }
    }
    
}
