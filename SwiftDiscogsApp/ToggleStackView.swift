//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A stack view that allows only one of its arranged subviews to be visible at
/// a time. Note that this applies only to its *arranged* subviews, which are
/// a subset of all the stack's subviews.
open class ToggleStackView: UIStackView {

    // MARK: - Public Properties

    /// The arranged subview that will be visible. All others will be hidden.
    open var activeView: UIView? {
        didSet {
            if oldValue != activeView {
                previousActiveView = oldValue

                arrangedSubviews.forEach { (subview) in
                    subview.isHidden = (activeView !== subview)
                }
            }
        }
    }

    /// The arranged subview that was active before the current active one was
    /// activated.
    open var previousActiveView: UIView?

    // MARK: - UIStackView

    open override func addArrangedSubview(_ view: UIView) {
        let alreadyHasArrangedSubviews = !arrangedSubviews.isEmpty
        super.addArrangedSubview(view)

        if activeView != nil  {
            view.isHidden = true
        } else if !alreadyHasArrangedSubviews {
            activeView = view
        } else {
            // leave it the way it is.
        }
    }

    /// Remove the specified arranged subview. If it's the active view, make
    /// the previously-active one active again. If the previously-active one is
    /// `nil`, then activate the *first* arranged subview.
    open override func removeArrangedSubview(_ view: UIView) {
        let isActiveView = (view === activeView)
        super.removeArrangedSubview(view)

        if isActiveView {
            if previousActiveView != nil {
                activeView = previousActiveView
            } else {
                activeView = arrangedSubviews.first
            }
        }
    }

}
