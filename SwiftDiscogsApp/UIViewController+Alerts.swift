//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public extension UIViewController {

    /// Show an alert for a specific error. The alert's title will be empty if
    /// none is specified, and the message will always be the error's
    /// `localizedDescription`.
    ///
    /// - parameter error: The error that triggered the alert.
    /// - parameter title: The text to use for the alert's title. If none is
    ///             specified, then the title will be blank.
    public func presentAlert(for error: Error,
                             title: String? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "This ain't good.",
                                                style: .cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
