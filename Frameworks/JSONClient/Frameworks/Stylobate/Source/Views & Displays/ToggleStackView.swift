//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A stack view that allows only one of its arranged subviews to be visible at
/// a time. Note that this applies only to its *arranged* subviews, which are
/// a subset of all the stack's subviews.
open class ToggleStackView: UIStackView {

    // MARK: - Public Properties

    /// The arranged subview that will be visible. All others will be hidden.
    /// If it's set to `nil`, however, _all_ subviews will be unhidden again.
    open var activeView: UIView? {
        didSet {
            if oldValue != activeView {
                previousActiveView = oldValue

                if activeView != nil {
                    arrangedSubviews.forEach { (subview) in
                        subview.isHidden = (activeView !== subview)
                    }
                } else {
                    arrangedSubviews.forEach { (subview) in
                        subview.isHidden = false
                    }
                }
            }
        }
    }

    /// When set to `true`, the rendered stack in the storyboard includes *all*
    /// subviews, not just the active one. This is useful for preventing
    /// constraints errors.
    @IBInspectable open var showsAllViewsInStoryboard: Bool = false {
        didSet {
            if showsAllViewsInStoryboard {
                activeView = nil
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

        if activeView != nil {
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
        super.removeArrangedSubview(view)

        if view === activeView {
            activeView = previousActiveView ?? arrangedSubviews.first
        }
    }

}
