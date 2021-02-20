//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `UIView` that has an associated view model. This is usually, though not
/// required to be, set as the root view of a view controller.
open class Display: UIView {

    /// The containing view controller's navigation item.
    @IBOutlet open weak var navigationItem: UINavigationItem?

    /// Update the display, if necessary. By default, this does nothing.
    open func refresh() {
        // Nothing.
    }

}
