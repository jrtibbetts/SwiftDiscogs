//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public extension UIView {

    /// Put a subview behind all of its siblings.
    ///
    /// - parameter subview: The view to banish.
    func banish(_ subview: UIView?) {
        if let subview = subview {
            subview.isHidden = true
            sendSubviewToBack(subview)
        }
    }

    /// Put a subview in front of all of its siblings.
    ///
    /// - parameter subview: The view to banish.
    func summon(_ subview: UIView?) {
        if let subview = subview {
            bringSubviewToFront(subview)
            subview.isHidden = false
        }
    }

}
