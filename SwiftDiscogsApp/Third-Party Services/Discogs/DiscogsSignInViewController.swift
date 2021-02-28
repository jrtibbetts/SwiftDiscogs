//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
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
        let promise = DiscogsManager.discogs.authorize(presentingViewController: self,
                                                       callbackUrlString: AppDelegate.shared.callbackUrl.absoluteString)
        promise.then { _ -> Promise<UserIdentity> in
            return DiscogsManager.discogs.userIdentity()
            }.done { [weak self] _ in
                self?.signInStatusStack.activeView = self?.signedInLabel
                self?.dismiss(animated: true, completion: nil)
            }.catch { (error) in    // not weak self because of Bundle(for:)
                self.presentAlert(for: error, title: L10n.discogsSignInFailed)
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
