//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A view controller that can display both a table view and a collection view,
/// perhaps depending on the screen size and orientation.
open class CollectionAndTableViewController: UIViewController {

    // MARK: Outlets

    open var display: CollectionAndTableDisplay?

    // MARK: Properties

    open var model: CollectionAndTableModel?
    
    // MARK: UIViewController overrides

    open override func viewDidLoad() {
        super.viewDidLoad()
        display?.model = model
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        display?.refresh()
    }

}
