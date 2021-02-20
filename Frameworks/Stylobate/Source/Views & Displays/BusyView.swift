//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Implemented by views that can indicate when an operation is in progress,
/// such as with a spinner or progress bar. However, this protocol doesn't
/// force the implementation to indicate this with a *view*; the implementation
/// could just as well play a sound, dim or disable itself, or something else.
public protocol BusyView: class {

    /// Signature of a block to execute when an activity is stopped or
    /// started.
    typealias ActivityCompletion = () -> Void

    /// Start the activity, and execute the optional completion when it's
    /// finished.
    ///
    /// - parameter completion: The block to execute when the activity has
    ///             finished starting. (Yes, really.)
    func startActivity(completion: ActivityCompletion?)

    /// Stop the activity, and execute the optional completion when it's
    /// finished.
    ///
    /// - parameter completion: The block to execute when the activity has
    ///             finished stopping. (Yes, really.)
    func stopActivity(completion: ActivityCompletion?)

}
