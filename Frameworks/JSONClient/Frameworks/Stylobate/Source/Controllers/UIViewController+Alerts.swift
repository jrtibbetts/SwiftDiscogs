//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public extension UIViewController {

    /// Show an OK alert with a specified message and optional title.
    ///
    /// - parameter message: The body of the alert.
    /// - parameter title: The alert's title. If none is specified, then the
    ///             title will be blank.
    /// - parameter completion: An optional block that's called when the alert's
    ///             OK button has been pressed. It takes no arguments and
    ///             returns nothing.
    func presentAlert(message: String,
                      title: String? = nil,
                      completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: completion)
    }

    /// Show an OK alert for a specific error. The alert's title will be empty
    /// if none is specified, and the message will always be the error's
    /// `localizedDescription`.
    ///
    /// - parameter error: The error that triggered the alert.
    /// - parameter title: The text to use for the alert's title. If none is
    ///             specified, then the title will be blank.
    /// - parameter completion: An optional block that's called when the alert's
    ///             OK button has been pressed. It takes no arguments and
    ///             returns nothing.
    func presentAlert(for error: Error,
                      title: String? = nil,
                      completion: (() -> Void)? = nil) {
        presentAlert(message: error.localizedDescription,
                     title: title,
                     completion: completion)
    }

}
