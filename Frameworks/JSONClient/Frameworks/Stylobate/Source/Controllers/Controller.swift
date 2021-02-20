//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `UIViewController` that has outlets to a `Model` and a `Display`, and
/// connects them when the view is loaded.
public protocol Controller: class {

    /// The `Display` object that controls the UI. Since this protocol is
    /// designed to be implemented by `UIViewController`s, it's recommended
    /// that view controllers implement this by returning the `view` and
    /// casting it to the display type. This is also why there's no setter,
    /// since `UIViewController`s that are loaded from storyboards can't have
    /// their `view`s replaced programmatically (as far as I can tell), and it
    /// would be too easy to get the `view` and `display` out of sync if
    /// `display` is a settable, stored property, instead of a computed one.
    var display: Display? { get }

}
