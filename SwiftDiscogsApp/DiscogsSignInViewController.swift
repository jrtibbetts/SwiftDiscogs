//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import Stylobate
import SwiftDiscogs

/// The view controller that explains what Discogs is and provides a button to
/// bring up the Discogs authentication page in a modal web view controller.
open class DiscogsSignInViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var checkingStatusView: UIView!

    @IBOutlet weak var signedInLabel: UILabel!

    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var signInStatusStack: ToggleStackView!

    // MARK: - Private Properties
    
    /// The REST client.
    private var discogs: Discogs = DiscogsClient.singleton!

    // MARK: - Actions
    
    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    @IBAction func signInToDiscogs(signInButton: UIButton?) {
        signInStatusStack.activeView = checkingStatusView
        let promise = discogs.authorize(presentingViewController: self,
                                        callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise.then { [unowned self] (credential) -> Promise<UserIdentity> in
            return self.discogs.userIdentity()
            }.done { [weak self] (userIdentity) in
                self?.signInStatusStack.activeView = self?.signedInLabel
                self?.dismiss(animated: true, completion: nil)
            }.catch { (error) in    // not weak self because of Bundle(for:)
                let alertTitle = NSLocalizedString("discogsSignInFailed",
                                                   tableName: nil,
                                                   bundle: Bundle(for: type(of: self)),
                                                   value: "Discogs sign-in failed",
                                                   comment: "Title of the alert that appears when sign-in is unsuccessful.")
                self.presentAlert(for: error, title: alertTitle)
        }
    }

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()
        signInStatusStack.activeView = signInButton
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if discogs.isSignedIn {
            signInStatusStack.activeView = signedInLabel
            dismiss(animated: true, completion: nil)
        }
    }

}
