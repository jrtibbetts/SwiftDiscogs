//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

/// The view controller that explains what Discogs is and provides a button to
/// bring up the Discogs authentication page in a modal web view controller.
open class DiscogsSignInViewController: UIViewController {
    
    // MARK: - Private Properties
    
    /// The REST client.
    fileprivate var discogs: Discogs = DiscogsClient.singleton!

    // MARK: - Actions
    
    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    @IBAction func signInToDiscogs(signInButton: UIButton?) {
        signInButton?.setTitle("Signing In…", for: .disabled)
        signInButton?.isEnabled = false

        let promise = discogs.authorize(presentingViewController: self,
                                         callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise.then { [unowned self] (credential) -> Promise<UserIdentity> in
            return self.discogs.userIdentity()
            }.done { [unowned self] (userIdentity) in

            self.performSegue(withIdentifier: "signInSuccessful", sender: self)
            signInButton?.isEnabled = true
            }.catch { (error) in    // not weak self because of Bundle(for:)
                signInButton?.isEnabled = false
                let alertTitle = NSLocalizedString("discogsSignInFailed",
                                                   tableName: nil,
                                                   bundle: Bundle(for: type(of: self)),
                                                   value: "Discogs sign-in failed",
                                                   comment: "Title of the alert that appears when sign-in is unsuccessful.")
                self.presentAlert(for: error, title: alertTitle)
        }
    }
    
    @IBAction func returnToLoginScene(unwindSegue: UIStoryboardSegue) {
        let alert = UIAlertController(title: "Unimplemented", message: "You can't yet sign out of Discogs.com.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIViewController
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.description == "signInSuccessful",
            let searchVC = segue.destination as? DiscogsSearchViewController {
            searchVC.discogs = discogs
        }
    }
    
}
