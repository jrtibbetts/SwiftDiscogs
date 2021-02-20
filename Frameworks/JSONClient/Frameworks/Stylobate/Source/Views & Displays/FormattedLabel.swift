//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `UILabel` that uses its initial `text` value (such as one set in a
/// storyboard) as a `printf()`-style formatter that gets applied to all
/// subsequent text assignments. Attributed strings ignore the format.
@IBDesignable open class FormattedLabel: UILabel {

    // MARK: - UILabel Properties

    /// If the label has been added to a superview, and if its `text` value at
    /// the time it was added to the superview contains `printf()`-style
    /// formatting characters, format the new value and set it as the `text`.
    /// Otherwise, set the new text as-is.
    open override var text: String? {
        get {
            return super.text
        }

        set {
            if let newValue = newValue, let formatString = formatString {
                let formattedNewValue = String(format: formatString, newValue)

                if formattedNewValue != formatString {
                    super.text = formattedNewValue
                } else {
                    super.text = newValue
                }
            } else {
                super.text = newValue
            }
        }
    }

    // MARK: - Internal Properties

    /// The value of the label's `text` property *when the label was added to
    /// its superview*. This is used as a formatting string for all subsequent
    /// programmatic `text` setters.
    internal var formatString: String?

    // MARK: - UILabel Functions

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        formatString = text
    }

}
