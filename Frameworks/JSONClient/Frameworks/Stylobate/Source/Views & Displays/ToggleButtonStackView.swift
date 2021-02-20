//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

/// A `UIStackView` that allows only one button to be selected at a time, and
/// when one is selected, the others are hidden. When none are selected, _all_
/// the buttons are shown.
class ToggleButtonStackView: ToggleStackView {

    /// If this is not `nil`, hide all the other arranged subviews and set
    /// `activeView.isSelected` to `true`. If it's `nil`, then unselect the
    /// current `activeView` (if any) and set its `isSelected` to `false`.
    override var activeView: UIView? {
        didSet {
            (activeView as? UIButton)?.isSelected = true

            arrangedSubviews.filter({ $0 != activeView }).forEach { (subview) in
                (subview as? UIButton)?.isSelected = false
            }
        }
    }

}
