//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import Stylobate
import SwiftDiscogs
import UIKit

/// The view controller that explains what Discogs is and provides a button to
/// bring up the Discogs authentication page in a modal web view controller.
open class DiscogsSignInViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var checkingStatusView: UIView!

    @IBOutlet weak var signedInLabel: UILabel!

    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var signInStatusStack: ToggleStackView!

    // MARK: - Actions

    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    @IBAction func signInToDiscogs(signInButton: UIButton?) {
        signInStatusStack.activeView = checkingStatusView

        Task {
            do {
                guard let discogs = DiscogsManager.discogs as? OAuth1JSONClient else {
                    return
                }

                let _ = try await discogs.authorize(callbackUrl: AppDelegate.shared.callbackUrl,
                                                    presentOver: self.view)

                self.signInStatusStack.activeView = self.signedInLabel
                self.dismiss(animated: true, completion: nil)
            } catch {
                self.presentAlert(for: error, title: L10n.discogsSignInFailed)
            }
        }
    }

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()
        signInStatusStack.activeView = signInButton
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if DiscogsManager.discogs.isSignedIn {
            signInStatusStack.activeView = signedInLabel
            dismiss(animated: true, completion: nil)
        }
    }

}
