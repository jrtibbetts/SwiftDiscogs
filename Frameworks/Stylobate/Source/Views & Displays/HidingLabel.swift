//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

/// A `UILabel` that sets its `isHidden` flag to `false` if its `text` or
/// `attributedText` fail to meet certain criteria--by default, these criteria
/// are
///  - if both are `nil`, and
///  - if both are empty strings (but _not_ strings consisting only of
///    whitespace)
///
/// The `shouldHideAttributedText` and `shouldHideText` properties can be set
/// to some other predicates, if desired.
@IBDesignable open class HidingLabel: UILabel {

    // MARK: - Typealiases

    /// Signature for functions or blocks that determine whether the
    /// `attributedText` is valid.
    public typealias AttributeTextHidingPredicate = (NSAttributedString?) -> Bool

    /// Signature for functions or blocks that determine whether the
    /// `text` is valid.
    public typealias TextHidingPredicate = (String?) -> Bool

    // MARK: - Properties

    /// The predicate that determines whether the `attributedText` meets the
    /// criteria for hiding the label. By default, this will return `true` if
    /// it's `nil` or empty.
    open var shouldHideAttributedText: AttributeTextHidingPredicate = { (attributedString) in
        return attributedString == nil || attributedString!.string.isEmpty
    }

    /// The predicate that determines whether the `text` meets the criteria for
    /// hiding the label. By default, this will return `true` if it's `nil` or
    /// empty.
    open var shouldHideText: TextHidingPredicate = { (string) in
        return string == nil || string!.isEmpty
    }

    /// Hide the label if both `shouldHideText()` and
    /// `shouldHideAttributedText()` are `true`.
    open func hideIfMatchesPredicates() {
        isHidden = shouldHideText(text) && shouldHideAttributedText(attributedText)
    }

    // MARK: - UILabel

    open override var attributedText: NSAttributedString? {
        didSet {
            hideIfMatchesPredicates()
        }
    }

    open override var text: String? {
        didSet {
            hideIfMatchesPredicates()
        }
    }

}
