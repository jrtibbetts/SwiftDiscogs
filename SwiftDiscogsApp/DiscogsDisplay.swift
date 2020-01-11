//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// Implemented by objects that control the UI components of a Discogs view
/// controller.
open class DiscogsDisplay: CollectionAndTableDisplay {

    /// Lay out and configure subviews. This is typically called during the
    /// view controller's `viewDidLoad()` function.
    ///
    /// - Parameter navigationItem: The view controller's navigation item. The
    ///             view controller's search controller can be obtained from
    ///             this.
    ///
    /// - SeeAlso: `tearDown`
    func setUp(navigationItem: UINavigationItem) {

    }

    /// Shut down, turn off, and/or remove any UI components that need explicit
    /// removal.
    func tearDown() {

    }

}
