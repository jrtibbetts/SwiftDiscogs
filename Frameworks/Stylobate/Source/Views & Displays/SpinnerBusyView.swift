//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Implemented by views that show a spinner when an activity is in progress.
/// The default implementation will add a `UIActivityIndicatorView` if your
/// implementation doesn't set one.
public protocol SpinnerBusyView: BusyView {

    /// The spinner to display. Your implementation must create a property or
    /// outlet for it, but doesn't have to initialize it or connect it in a
    /// storyboard or nib, because the default implementation can create one.
    var spinner: UIActivityIndicatorView? { get set }

}

// MARK: - SpinnerBusyView Default Implementation

public extension SpinnerBusyView where Self: UIView {

    /// Start the activity by showing and starting a spinner. If the spinner
    /// is `nil`, one will be added automatically.
    ///
    /// - parameter completion: The block to execute when the activity has
    ///             finished starting. (Yes, really.)
    func startActivity(completion: BusyView.ActivityCompletion? = nil) {
        if spinner == nil {
            if #available(iOS 13, *) {
                spinner = UIActivityIndicatorView(style: .large)
            } else {
                spinner = UIActivityIndicatorView(style: .whiteLarge)
            }
        }

        if let spinner = spinner {
            if spinner.superview == nil {
                addSubview(spinner)
                spinner.centerInSuperview()
                setNeedsUpdateConstraints()
                layoutIfNeeded()
            }

            spinner.hidesWhenStopped = true
            spinner.startAnimating()
            completion?()
        }
    }

    func stopActivity(completion: BusyView.ActivityCompletion? = nil) {
        spinner?.stopAnimating()
        completion?()
    }

}
