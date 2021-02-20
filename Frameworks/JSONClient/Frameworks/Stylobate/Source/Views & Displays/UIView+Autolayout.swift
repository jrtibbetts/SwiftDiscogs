//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public extension UIView {

    /// Add constraints to center the view horizontally and vertically in its
    /// superview. Also add constraints to ensure that this view's frame doesn't
    /// extend past any of the superview's margins.
    func centerInSuperview() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false

            let marginsGuide = superview.layoutMarginsGuide
            let views = ["leading": marginsGuide, "trailing": marginsGuide, "view": self]
            NSLayoutConstraint.constraints(withVisualFormat: "[leading]-[view]-[trailing]",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterY,
                metrics: nil,
                views: views).forEach { (constraint) in
                    constraint.isActive = true
            }
            centerXAnchor.constraint(equalTo: marginsGuide.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: marginsGuide.centerYAnchor).isActive = true
        }
    }

}

public extension Array where Element: NSLayoutConstraint {

    /// Activate all the constraints in the array.
    func activate() {
        NSLayoutConstraint.activate(self)
    }

    /// Deactivate all the constraints in the array.
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }

}
